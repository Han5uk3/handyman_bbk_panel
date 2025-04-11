import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/modules/login/login_page.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.white,
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
