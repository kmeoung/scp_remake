import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/pages/login.dart';

void main() => runApp(const Scp());

/// SCP Project
class Scp extends StatelessWidget {
  const Scp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: CustomColors.yellow,
        backgroundColor: CustomColors.white,
        appBarTheme: const AppBarTheme(
          color: CustomColors.deepPurple,
          centerTitle: false,
          foregroundColor: CustomColors.white,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: CustomColors.deepPurple),
          bodyText2: TextStyle(color: CustomColors.deepPurple),
          headline1: TextStyle(color: CustomColors.deepPurple),
          headline2: TextStyle(color: CustomColors.deepPurple),
        ),
      ),
      home: LoginPage(),
    );
  }
}
