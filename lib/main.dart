import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/screen/addphotomemo_screen.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/detailedview_scree.dart';
import 'package:lesson3/screen/like_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';
import 'package:lesson3/screen/signin_screen.dart';
import 'package:lesson3/screen/signup_screen.dart';
import 'package:lesson3/screen/userhome_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(lesson3());
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}




class lesson3 extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        AddPhotoMemoScreen.routeName: (context) => AddPhotoMemoScreen(),
        DetailedViewScreen.routeName: (context) => DetailedViewScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SharedWithScreen.routeName: (context) => SharedWithScreen(),
        CommentScreen.routeName:(context)=>CommentScreen(),
        LikeScreen.routeName:(context)=>LikeScreen(),
      },
    );
  }
}
