import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/route_func_gen.dart';

Builder routeFuncGen(BuilderOptions options) => LibraryBuilder(
      RouteFuncGenerator(),
      generatedExtension: '.r.dart',
    );

class GetxRoute {
  final int? navId;
  final String path;
  const GetxRoute(this.path, {this.navId});
}
