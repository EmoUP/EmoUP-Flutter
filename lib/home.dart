import 'package:emoup/Drawer/about.dart';
import 'package:emoup/Drawer/notes.dart';
import 'package:emoup/Therapies/music.dart';
import 'package:emoup/Drawer/people.dart';
import 'package:emoup/Models/user.dart';
import 'package:emoup/OnBoarding/login.dart';
import 'package:emoup/Services/userOps.dart';
import 'package:emoup/Therapies/inspiration.dart';
import 'package:emoup/Therapies/video.dart';
import 'package:emoup/const.dart';
import 'package:emoup/Drawer/doctor.dart';
import 'package:emoup/Drawer/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double w,h;
  SharedPreferences prefs;
  String pfp, name, uid;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    String temp = prefs.getString("uid");
    String temp1 = prefs.getString("name");
    setState(() {
      uid = temp;
      name = temp1;      
    });
    if(prefs.containsKey("pfp")) {
      String temp = prefs.getString("pfp");
      setState(() {
        pfp = temp;     
        loading = false;   
      });
    } else {
      User curr = await getUserInfo(uid);
      var response = await get(Uri.parse(curr.profilePic));
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path;
      var filePathAndName = documentDirectory.path + '/pfp.jpg'; 
      await Directory(firstPath).create(recursive: true); 
      File file2 = new File(filePathAndName);   
      file2.writeAsBytesSync(response.bodyBytes);  
      await prefs.setString("pfp", filePathAndName);
      setState(() {
        pfp = filePathAndName;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        child: Drawer(
          child: loading ? Center(
            child: SpinKitWanderingCubes(
              color: Colors.red,
              size: 20,
            )
          ) : Column(
            children: [
              Container(
                height: 0.95 * h,
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
                        backgroundImage: FileImage(File(pfp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.04 * h),
                        child: Text("Welcome $name !",
                        style: GoogleFonts.poppins(
                          fontSize: 22
                        )
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 0.2 * w),
                      title: Text("Reports", style: GoogleFonts.poppins(fontSize: 16)),
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.025 * w),
                        child: Icon(Icons.assignment_outlined, size: 40),
                      ),
                      onTap: () {
                        navigateTo(context, Report(uid: uid, pfp: FileImage(File(pfp))));
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 0.2 * w),
                      title: Text("Doctor", style: GoogleFonts.poppins(fontSize: 16)),
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.025 * w),
                        child: Icon(Icons.medical_services_outlined, size: 40),
                      ),
                      onTap: () {
                        navigateTo(context, Doctor());
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 0.2 * w),
                      title: Text("People", style: GoogleFonts.poppins(fontSize: 16)),
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.025 * w),
                        child: Icon(Icons.group_outlined, size: 40),
                      ),
                      onTap: () {
                        navigateTo(context, People(uid: uid, name: name));
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 0.2 * w),
                      title: Text("About", style: GoogleFonts.poppins(fontSize: 16)),
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.025 * w),
                        child: Icon(Icons.info_outline, size: 40),
                      ),
                      onTap: () {
                        navigateTo(context, About());
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 0.2 * w),
                      title: Text("Logout", style: GoogleFonts.poppins(fontSize: 16)),
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.025 * w),
                        child: Icon(Icons.exit_to_app_outlined, size: 40),
                      ),
                      onTap: () async {
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
                    ),
                  ],
                ),
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
            navigateTo(context, MusicTherapy(uid: uid));
          }, "Music Therapy", Color(0xFFFCD3E1), Color(0xFFF15858), Icons.music_note),
          therapy(() {
            navigateTo(context, InspirationTherapy(uid: uid));
          }, "Inspiration Therapy", Color(0xFFC4E6FF), Color(0xFF2D9AED), Icons.lightbulb),
          therapy(() async {
            await launch(expression);
          }, "Expression Therapy", Color(0xFFFEDDBA), Color(0xFFE4852C), Icons.message),
          therapy(() {
            navigateTo(context, VideoTherapy());
          }, "Virtual Forest", Color(0xFFD3EA9C), Color(0xFF75B322), Icons.park),
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
          color: bg,
          boxShadow: [
            new BoxShadow(color: bg, blurRadius: 15.0, spreadRadius: 2),
          ],
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