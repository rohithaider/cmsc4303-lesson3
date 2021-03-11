import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
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
          title: Text('Sign In'),
        ),
        body: Text('Sign In'));
  }
}

class _Controller {
  _SignInState state;
  _Controller(this.state);
}
