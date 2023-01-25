import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/sign_in_page.dart';
import 'package:instagram_clone/servis_pages/auth_service.dart';
import 'package:instagram_clone/servis_pages/prefs_service.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

bool isLogged = true;

class _SplashPageState extends State<SplashPage> {

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _initNotification() async {
    _firebaseMessaging.getToken().then((value) async {
      String fcnToken = value.toString();
      await Prefs.saveFCM(fcnToken);
      String token = await Prefs.loadFCM();
      print("TOKEN: $token");
    });
  }


  @override
  void initState() {
    _initNotification();
    startPage();
    super.initState();
  }

  void startPage() async {
    await Future.delayed(const Duration(seconds: 2));
    isLogged = AuthService.isLoggedIn();
    if (isLogged) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(193, 53, 132, 1),
              Color.fromRGBO(131, 58, 180, 1),
            ]
          )
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text("Instagram", style: TextStyle(color: Colors.white,fontSize: 50, fontFamily: "billabong"),),
              ),
            ),
            Text("All rights reserved", style: TextStyle(color: Colors.white,fontSize: 16),)
          ],
        ),
      ),
    );
  }
}
