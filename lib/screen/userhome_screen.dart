import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/screen/addphotomemo_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  _Controller con;
  User user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    return WillPopScope(
      onWillPop: () => Future.value(false), //android system back button disabled
      child: Scaffold(
        appBar: AppBar(
          title: Text('User home'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user.displayName ?? 'N/A'),
                accountEmail: Text(user.email),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: con.addButton,
        ),
        body: Text('User home ${user.email}'),
      ),
    );
  }
}

class _Controller {
  _UserHomeState state;
  _Controller(this.state);
  void addButton() async {
    await Navigator.pushNamed(state.context, AddPhotoMemoScreen.routeName,
        arguments: {Constant.ARG_USER: state.user});
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      //do nothing
    }
    Navigator.of(state.context).pop(); //closing drawer
    Navigator.of(state.context).pop(); //pop user home screen
  }
}