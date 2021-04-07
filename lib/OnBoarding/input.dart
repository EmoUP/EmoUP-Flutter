import 'dart:io';

import 'package:emoup/Services/userOps.dart';
import 'package:emoup/const.dart';
import 'package:emoup/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';

class Input extends StatefulWidget {
  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {

  String deviceId;
  double w,h;
  bool loading = false;
  String uid;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = prefs.getString("uid");
    setState(() {
      uid = temp;
      loading = false;      
    });
  }


  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Device Setup",
          style: GoogleFonts.poppins(
            color: eblue,
            fontSize: 24
          ),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: Center(
        child: loading ? Center(
            child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : Column(
          children: [ 
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.05 * h),
              child: Text(
              "Setup your EmoUP Buddy",
                style: GoogleFonts.poppins(
                  color: egreen,
                  fontSize: 24
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                deviceId = await scanner.scan();
              },
              child: Card(
                child: Image.asset("assets/images/qr.png"),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.1 * h),
              child: Text(
              "----------OR----------",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 18
                ),
              ),
            ),
            Text(
              "Continue with your mobile camera",
              style: GoogleFonts.poppins(
                color: eorange,
                fontSize: 18
              ),
            ),
            SizedBox(
              height: 0.05 * h,
            ),
            FloatingActionButton(
              onPressed: () async {
                if(deviceId != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Do you want to continue linking the device?"),
                        actions: [
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              await linkDevice(deviceId, uid);
                              navigateToPush(context, Home());
                            },
                          )
                        ],
                      );
                    }
                  );
                } else {
                  navigateToPush(context, Home());
                }
              },
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      )
    );
  }
}