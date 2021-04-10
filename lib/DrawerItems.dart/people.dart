import 'package:emoup/Models/user.dart';
import 'package:emoup/Services/userOps.dart';
import 'package:emoup/Therapies/inspiration.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class People extends StatefulWidget {
  @override
  _PeopleState createState() => _PeopleState();
}

bool loading = true;
List<String> name;

List<User> lst;

class _PeopleState extends State<People> {
  bool loading = true;
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    lst = await getUsers();
    for (int i = 0; i < lst.length; i++) {
      name[i] = lst[i].name;
    }
    setState(() {
      loading = false;
    });
    print(lst);
  }

  @override
  double h, w;

  final List<String> entries = <String>['A', 'B', 'C', 'D', 'E'];
  List<Color> color = [
    Color(0xFFFCD3E1),
    Color(0xFFC4E6FF),
    Color(0xFFFEDDBA),
    Color(0xFFD3EA9C)
  ];
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF405CC7),
          title: Text(
            "People",
            style: GoogleFonts.poppins(fontSize: 24, color: white),
          ),
          centerTitle: true,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      people(() {}, entries[index], color[index % 4],
                          Colors.black54, Icons.chat)
                    ],
                  );
                }));
  }

  people(Function fn, String title, Color bg, Color fg, IconData icon) {
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
              Text(
                title,
                style: GoogleFonts.poppins(color: fg, fontSize: 24),
              ),
              Icon(
                icon,
                color: fg,
                size: 40,
              )
            ],
          ),
        ));
  }

  sendMessage() {}
}
