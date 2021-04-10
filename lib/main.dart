import 'package:emoup/OnBoarding/login.dart';
import 'package:emoup/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wasterage(),
    );
  }
}

class Wasterage extends StatefulWidget {
  @override
  _WasterageState createState() => _WasterageState();
}

class _WasterageState extends State<Wasterage> {
  bool loading = true, login = false;

  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("uid")) {
      setState(() {
        login = true;        
      });
    }
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: loading ? Center(
            child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : login ? Home() : Login(),
      ),
    );
  }
}