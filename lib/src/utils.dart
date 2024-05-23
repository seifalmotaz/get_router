import 'package:get_router/builder.dart';
import 'package:source_gen/source_gen.dart';

Iterable<AnnotatedElement> getAnnotiatedClasses(LibraryReader reader) =>
    reader.annotatedWith(TypeChecker.fromRuntime(GetxRoute));
