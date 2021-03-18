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
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
        ),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Create an account', style: Theme.of(context).textTheme.headline5),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: null,
                    onSaved: null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: null,
                    onSaved: null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password confirm',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    validator: null,
                    onSaved: null,
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Text(
                      'Create',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
}
