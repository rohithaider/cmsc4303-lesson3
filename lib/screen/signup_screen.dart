import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an acoount'),
      ),
      body: Text('sign up'),
    );
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
}
