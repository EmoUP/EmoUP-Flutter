import 'package:emoup/Models/user.dart';
import 'package:emoup/Services/userOps.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(pfp),
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
          therapy(() {}, "Expression Therapy", Color(0xFFFEDDBA), Color(0xFFE4852C), Icons.message),
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