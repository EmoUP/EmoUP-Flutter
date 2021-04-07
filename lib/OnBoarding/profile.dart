import 'dart:io';
import 'package:emoup/Models/user.dart';
import 'package:emoup/Services/login.dart';
import 'package:emoup/const.dart';
import 'package:emoup/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User user = new User();
  PlatformFile _upload;
  String dob, uid;
  double w,h;
  TextEditingController c1 = new TextEditingController();
  TextEditingController c2 = new TextEditingController();
  bool loading = true;

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
      body: Center(
        child: loading ? Center(
            child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Colors.white,
              elevation: 5,
              shape: CircleBorder(),
              child: GestureDetector(
                onTap: () => {
                  pickImage()
                },
                child: CircleAvatar(
                  radius: 0.1 * h,
                  backgroundColor: Colors.white,
                  backgroundImage: _upload != null ? FileImage(File(_upload.path)) : AssetImage('assets/images/add.png'),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    inputField("Name", Icon(Icons.person)),
                    inputField("D.O.B", Icon(Icons.calendar_today)),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      onPressed: () async {
                        setState(() {
                          loading = true;                          
                        });
                        await uploadPfp(_upload, uid);
                        //await completeProfile(user, uid);
                        setState(() {
                          loading = false;                          
                        });
                        navigateToPush(context, Home());
                      }, 
                      child: Text("Next", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        )
                      ),
                      elevation: 5,
                    )
                  ],
                ),
              )
            )
          ],
        )
      )
    );
  }

  Widget inputField(String title, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(100),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(100),
          ),
          fillColor: Color.alphaBlend(
            Colors.blue.withOpacity(.07),
            Colors.grey.withOpacity(.04),
          ),
          labelStyle: TextStyle(fontSize: 18),
          prefixIcon: icon,
          filled: true,
          labelText: title
        ),
        onChanged: (value) {
          if(title == "Name") {
            user.name = value;
            c1.text = value;
            c1.selection = TextSelection.fromPosition(TextPosition(offset: c1.text.length));
          } 
        },
        onTap: () {
          if(title == "D.O.B") {
            pickDate();
          }
        },
        controller: title == "Name" ? c1 : c2,
      )
    );
  }

  pickImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );
    if (result != null) {
      setState(() {
        _upload = result.files.single;
      });
    } else {
      // User canceled the picker
    }
  }

  pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: DateTime.now(),
    );

    if(date != null) {
      setState(() {
        user.birth = DateFormat('yyyy-MM-dd').format(date);
        c2.text = user.birth;
      });
    } else {
      setState(() {
        user.birth = DateFormat('yyyy-MM-dd').format(DateTime.now());
        c2.text = user.birth;
      });
    }
  }
}