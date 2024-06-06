// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RouteFuncGenerator
// **************************************************************************

// >> [{"path": "/", "funcName": "handlerMyHomePage"}]
// Source library: package:example/pages/main.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:example/pages/main.dart';

/// Navigates to the `MyHomePage` page.
void toMyHomePage(String title) {
  Get.toNamed(
    '/',
    parameters: {
      // Pass constructor argument 'title'
      'title': title,
    },
  );
}

/// Handler function for the `MyHomePage` route.
Widget handlerMyHomePage() {
  // Extract route parameter 'title' with type String
  final String title = Get.parameters['title'] as String;
  // Create an instance of MyHomePage
  return MyHomePage(title: title);
}
