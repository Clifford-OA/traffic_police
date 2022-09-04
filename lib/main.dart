import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/home_screen.dart';
import 'package:traffic_police/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/utils/fetch_police_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Text(
              'Error',
              textDirection: TextDirection.ltr,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthClass>(
                create: (_) => AuthClass(),
              ),
              ChangeNotifierProvider<Police>(
                  create: (_) => Police(
                        false,
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                      ))
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Login',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: SplashPage(),
            ),
          );
        }

        // if not yet initialized show a process indicator
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FetchPoliceData _fetchPoliceData = new FetchPoliceData();

  @override
  void initState() {
    final authClass = Provider.of<AuthClass>(context, listen: false);
    // final firebaseUser = FirebaseAuth.instance.currentUser;
    final police = authClass.currentPolice;
    // print(uid);
    // print(uid.runtimeType);
    super.initState();
    _fetchPoliceData.loadUserData(context);
    Timer(const Duration(milliseconds: 4000), () {
      // if (uid == null ) {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // } else {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  police == null ? LoginScreen() : HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.white12],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: Center(
            child: Container(
          height: 200,
          child: Center(
            child: Image.asset("assets/police.png"),
          ),
        )),
      ),
    );
  }
}
