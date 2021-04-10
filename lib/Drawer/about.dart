import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

double h;
bool selected = false;
@override
double w;

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        selected = !selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text(
          "Our Team",
          style: GoogleFonts.poppins(fontSize: 24, color: white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Card(
                  margin: EdgeInsets.only(bottom: 0.02 * h),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
                ),
                SizedBox(height: 0.1 * h),
                Row(
                  children: [
                    card("https://media-exp1.licdn.com/dms/image/C4E03AQFlZb4rBcWdCw/profile-displayphoto-shrink_800_800/0/1617021351788?e=1623283200&v=beta&t=EQDOSVgjs_lIMUkbETf3vJvwvrZrTxhTdfyPT5E4E_M"),
                    details("Abhi Jain", "Flutter Developer")
                  ],
                ),
                Row(
                  children: [
                    card("https://media-exp1.licdn.com/dms/image/C4D03AQETOOY5eNrydQ/profile-displayphoto-shrink_400_400/0/1614148313090?e=1623283200&v=beta&t=0kDGa9ehLD7B7U0nTcYTLFpXBRTwvq6i6JEBeLbuIJg"),
                    details("Krati Jain", "UI Designer")
                  ],
                ),
                Row(
                  children: [
                    card("https://avatars.githubusercontent.com/u/44701159?v=4"),
                    details("Ajinkya Dandvate", "AI/ML Enthusiast")
                  ],
                ),
                Row(
                  children: [
                    card("https://media-exp1.licdn.com/dms/image/C4D35AQEBgOcn3MGHlQ/profile-framedphoto-shrink_400_400/0/1598363669611?e=1618120800&v=beta&t=E-YAew96zeOBhOB4M8CMquqIDffvDwpuhFx2dyCQBy4"),
                    details("Ajinkya Taranekar", "Backend Developer")
                  ],
                ),
                SizedBox(
                  height: 0.05 * h,
                )
              ],
            ),
            AnimatedPositioned(
              left: selected ? w * 0.2 : w * 0.35,
              width: selected ? 250.0 : 100.0,
              height: selected ? 100.0 : 300.0,
              top: selected ? 0.2 * h : 600.0,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected = !selected;
                  });
                },
                child: Image.asset('assets/images/logo.png')
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget card(String image) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
        child: Card(
          color: Colors.white24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0,
          child: Column(
            children: <Widget>[
              Container(
                height: w * 0.4,
                width: w * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(image, fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget details(String name, String bio) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: GoogleFonts.poppins(fontSize: 22)),
          SizedBox(
            height: 10,
          ),
          Text(bio, style: GoogleFonts.poppins(fontSize: 15))
        ],
      ),
    );
  }
}