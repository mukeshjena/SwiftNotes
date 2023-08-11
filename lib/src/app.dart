import 'package:SwiftNotes/src/res/strings.dart';
import 'package:SwiftNotes/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData(useMaterial3: true),
      home: HomeScreen(),
    );
  }
}
