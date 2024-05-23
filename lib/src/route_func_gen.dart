import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'utils.dart';

class RouteFuncGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final anotatedClasses = getAnnotiatedClasses(library);

    return '''
// Source library: ${library.element.source.uri}
// ${anotatedClasses.map((e) => e.annotation.read('path').literalValue as String).join(', ')}
''';
  }
}
