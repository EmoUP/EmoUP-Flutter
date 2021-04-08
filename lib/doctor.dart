import 'package:emoup/Services/doctor.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:emoup/Models/Doctor.dart' as Doc;
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Doctor extends StatefulWidget {
  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {

  List<Doc.Doctor> lst;
  double w,h;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<Doc.Doctor> temp = await getDoctors();
    setState(() {
      lst = temp;      
    });
    print(lst.length);
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text("Doctors",
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
          Expanded(
            child: ListView.builder(
              itemCount: lst.length,
              itemBuilder: (context, index) {
                return Card(
                  shadowColor: Color(0x80405CC7),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("Dr. "+lst[index].name)
                    ),
                    subtitle: Text(lst[index].address),
                    trailing: IconButton(
                      icon: Icon(Icons.navigation),
                      color: eblue,
                      onPressed: () {
                        MapsLauncher.launchCoordinates(lst[index].latitude, lst[index].longitude);
                      },
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  )
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}