import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double w,h;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset("assets/images/header.png", width: w),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.07 * h),
                child: Text("Therapy",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: white
                  ),
                )
              )
            ],
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 0.1 * h,
              margin: EdgeInsets.all(0.05 * w),
              padding: EdgeInsets.all(0.05 * w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFFCD3E1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Music Therapy",
                    style: GoogleFonts.poppins(
                      color: Color(0xFFF15858),
                      fontSize: 24
                    ),
                  ),
                  Icon(Icons.music_note, color: Color(0xFFF15858), size: 40,)
                ],
              ),
            )
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 0.1 * h,
              margin: EdgeInsets.all(0.05 * w),
              padding: EdgeInsets.all(0.05 * w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFC4E6FF)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Inspiration Therapy",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF2D9AED),
                      fontSize: 24
                    ),
                  ),
                  Icon(Icons.lightbulb, color: Color(0xFF2D9AED), size: 40,)
                ],
              ),
            )
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 0.1 * h,
              margin: EdgeInsets.all(0.05 * w),
              padding: EdgeInsets.all(0.05 * w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFFEDDBA)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Expression Therapy",
                    style: GoogleFonts.poppins(
                      color: Color(0xFFE4852C),
                      fontSize: 24
                    ),
                  ),
                  Icon(Icons.message, color: Color(0xFFE4852C), size: 40,)
                ],
              ),
            )
          ),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 0.1 * h,
              margin: EdgeInsets.all(0.05 * w),
              padding: EdgeInsets.all(0.05 * w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD3EA9C)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Virtual Forest",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF75B322),
                      fontSize: 24
                    ),
                  ),
                  Icon(Icons.park, color: Color(0xFF75B322), size: 40,)
                ],
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 0.05 * h),
              height: 0.1 * h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: eblue
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
}