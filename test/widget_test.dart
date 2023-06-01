// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_course_design/Theme/ThemeData.dart';
import 'package:flutter_course_design/pojo/User.dart';
import 'package:flutter_course_design/service/ProductService.dart';
import 'package:flutter_course_design/service/UserService.dart';
import 'package:flutter_course_design/service/lib/Request.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_course_design/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await login(User(username: 'root', password: '123456'));
  });
}
