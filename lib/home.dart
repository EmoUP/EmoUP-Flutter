import 'package:emoup/Models/user.dart';
import 'package:emoup/OnBoarding/login.dart';
import 'package:emoup/Services/userOps.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double w,h;
  SharedPreferences prefs;
  String pfp, name, uid;
  bool loading = true, cache = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    String temp = prefs.getString("uid");
    setState(() {
      uid = temp;      
    });
    if(prefs.containsKey("name")) {
      String temp = prefs.getString("name");
      setState(() {
        name = temp;        
      });
    } else {
      User curr = await getUserInfo(uid);
      setState(() {
        name = curr.name;
        pfp = curr.profilePic;    
        cache = false;  
        loading = false;  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: loading ? Center(
          child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : Column(
          children: [
            Container(
              height: 0.9 * h,
              child: Column(
                children: [
                  SizedBox(
                    height: 0.08 * h,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      radius: 0.1 * h,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(pfp),
                    ),
                  ),
                  SizedBox(
                    height: 0.02 * h,
                  ),
                  Text("Welcome $name !",
                    style: GoogleFonts.poppins(
                      fontSize: 22
                    )
                  ),
                ],
              ),
            ),
            Container(
              height: 0.1 * h,
              child: Column(
                children: [
                  FloatingActionButton.extended(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Do you really want to logout?"),
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
                                  await prefs.remove("uid");
                                  navigateToPush(context, Login());
                                },
                              )
                            ],
                          );
                        }
                      );
                    }, 
                    label: Text("Logout", style: TextStyle(fontSize: 16, color: Colors.black)),
                    icon: Icon(Icons.exit_to_app, size: 40, color: Colors.black,),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Made with ❤️ by Team Ozone",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text("Therapy",
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: white
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 0.02 * h),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
          ),
          therapy(() {
            print(pfp);
          }, "Music Therapy", Color(0xFFFCD3E1), Color(0xFFF15858), Icons.music_note),
          therapy(() {}, "Inspiration Therapy", Color(0xFFC4E6FF), Color(0xFF2D9AED), Icons.lightbulb),
          therapy(() async {
            await launch(expression);
          }, "Expression Therapy", Color(0xFFFEDDBA), Color(0xFFE4852C), Icons.message),
          therapy(() {}, "Virtual Forest", Color(0xFFD3EA9C), Color(0xFF75B322), Icons.park),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 0.02 * h),
              height: 0.1 * h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: eblue,
              ),
              child: Center(
                child: Text("Choose your therapy",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: white
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  therapy(Function fn, String title, Color bg, Color fg, IconData icon) {
    return GestureDetector(
      onTap: () {
        fn();
      },
      child: Container(
        height: 0.1 * h,
        margin: EdgeInsets.all(0.05 * w),
        padding: EdgeInsets.all(0.05 * w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: bg
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
              style: GoogleFonts.poppins(
                color: fg,
                fontSize: 24
              ),
            ),
            Icon(icon, color: fg, size: 40,)
          ],
        ),
      )
    );
  }
}