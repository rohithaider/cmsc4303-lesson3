import 'package:flutter/material.dart';
import 'package:lesson3/screen/signin_screen.dart';

void main() {
  runApp(lesson3());
}

class lesson3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
      },
    );
  }
}
