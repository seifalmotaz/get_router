import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'utils.dart';

/// Generates code for navigation helper functions based on annotations.
class RouteFuncGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    /// List of classes annotated with the route information.
    final annotatedClasses = getAnnotiatedClasses(library);

    if (annotatedClasses.isEmpty) return '';

    final buffer = StringBuffer();

    // Write source library information and imports
    buffer.writeln("// Source library: ${library.element.source.uri}");
    buffer.writeln("import 'package:get/get.dart';");
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln("import '${library.element.source.uri}';");

    for (final annotatedClass in annotatedClasses) {
      // Extract navigation ID and path from annotation
      final navId =
          annotatedClass.annotation.read('navId').literalValue as int?;
      final path =
          annotatedClass.annotation.read('path').literalValue as String;

      // Get class name and constructor
      final className = annotatedClass.element.displayName;
      final constructor =
          (annotatedClass.element as ClassElement).constructors.first;

      // Filter constructor parameters (excluding 'key')
      final constructorParams =
          List<ParameterElement>.from(constructor.parameters);
      constructorParams.removeWhere((element) => element.displayName == 'key');

      // Generate parameter list for constructor call
      final neededFields = constructorParams.map((e) =>
          '${e.type.getDisplayString(withNullability: true)} ${e.displayName}');

      // ** Function 1: Navigation helper for the class **
      buffer.writeln("/// Navigates to the `$className` page.");
      buffer.writeln("void to$className(${neededFields.join(', ')}) {");
      buffer.writeln("  Get.toNamed('$path', parameters: {");
      for (final field in constructorParams) {
        buffer
            .writeln("    // Pass constructor argument '${field.displayName}'");
        buffer.writeln("    '${field.displayName}': ${field.displayName},");
      }
      buffer.writeln("  },");
      if (navId != null) buffer.writeln("  id: $navId,");
      buffer.writeln(");");
      buffer.writeln("}");

      // ** Function 2: Handles route parameters and creates the class instance **
      buffer.writeln("/// Handler function for the `$className` route.");
      buffer.writeln("Widget handler$className() {");
      for (final param in constructorParams) {
        final paramName = param.displayName;
        final paramType = param.type.getDisplayString(withNullability: true);

        // Extract route parameter and handle default values
        buffer.writeln(
            "  // Extract route parameter '$paramName' with type $paramType");
        buffer.writeln(
            "  final $paramType $paramName = Get.parameters['$paramName'] as $paramType ${param.hasDefaultValue ? '?? ${param.defaultValueCode}' : ''};");
      }
      buffer.writeln("  // Create an instance of $className");
      buffer.writeln("  return $className(");
      for (var i = 0; i < constructorParams.length; i++) {
        final paramName = constructorParams[i].displayName;
        if (constructorParams[i].isNamed) {
          buffer.write("    $paramName: $paramName");
        } else {
          buffer.write("    $paramName");
        }
        if (i < constructorParams.length - 1) {
          buffer.write(", ");
        }
      }
      buffer.writeln(");");
      buffer.writeln("}");
    }

    return buffer.toString();
  }
}
