import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

double h;
bool selected = false;
@override
double w;

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    Future.delayed(Duration(seconds: 2), () {
      // Do something
      //
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
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(height: 0.1 * h),
                    // Text("Our", style: GoogleFonts.poppins(fontSize: 22)),
                    Row(
                      children: [
                        card(
                            "https://pbs.twimg.com/profile_images/1241769836226600960/fOVIYLeW_400x400.jpg"),
                        details("Abhi Jain", "Flutter Developer")
                      ],
                    ),
                    Row(
                      children: [
                        card(
                            "https://avatars.githubusercontent.com/u/44701159?v=4"),
                        details("Ajinkya Dandvate", "Data Scientist")
                      ],
                    ),
                    Row(
                      children: [
                        card(
                            "https://avatars.githubusercontent.com/u/44701159?v=4"),
                        details("Ajinkya Taranekar", "Backend Developer")
                      ],
                    ),
                    Row(
                      children: [
                        card(
                            "https://media-exp1.licdn.com/dms/image/C4D03AQETOOY5eNrydQ/profile-displayphoto-shrink_400_400/0/1614148313090?e=1623283200&v=beta&t=0kDGa9ehLD7B7U0nTcYTLFpXBRTwvq6i6JEBeLbuIJg"),
                        details("Krati Jain", "Flutter Developer")
                      ],
                    ),
                  ],
                ),
                AnimatedPositioned(
                  left: selected ? w * 0.2 : w * 0.35,
                  width: selected ? 250.0 : 100.0,
                  height: selected ? 100.0 : 300.0,
                  top: selected ? 10.0 : 600.0,
                  duration: const Duration(seconds: 2),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = !selected;
                        });
                      },
                      child: Image.asset('assets/images/logo.png')),
                )
              ],
            ),
          ),
        ));
  }

  Widget card(String image) {
    return Container(
      // height: 0.3 * h,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
        child: Card(
          color: Colors.white24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          shadowColor: eblue,
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
