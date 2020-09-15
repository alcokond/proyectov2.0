

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/notifier/auth_notifier.dart';
import 'package:flutter_login_ui/screens/login.dart';
import 'package:flutter_login_ui/screens/feed.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
    ChangeNotifierProvider(
      builder: (context)=> AuthNotifier(),
    )
  ],
  )
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CovidForce',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthNotifier>(
        builder: (context, notifier,child){
          return notifier.user != null ? Feed() : Login();
        },
      ),
    );
  }
}