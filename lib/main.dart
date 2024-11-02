import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:unix/loginpage.dart';
import 'package:unix/themprovider.dart';
// Import your ThemeProvider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'unix Aquatics',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LoginPage(),
    );
  }
}
