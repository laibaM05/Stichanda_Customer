import 'package:flutter/material.dart';
import '../theme/light_theme.dart';
import 'screen/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stitchanda',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const LoginPage(),
    );
  }
}