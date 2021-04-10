import 'package:emoup/DrawerItems.dart/addNote.dart';
import 'package:emoup/Models/note.dart';
import 'package:emoup/Services/note.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayNotes extends StatefulWidget {
  @override
  _DisplayNotesState createState() => _DisplayNotesState();
}

List<Notes> notes = [];
SharedPreferences prefs;
List<String> noteString = [];
String uid;
List<String> color = [];
List<String> date = [];

class _DisplayNotesState extends State<DisplayNotes> {
  bool loading = true;
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid");
    notes = await getNotes(uid);
    for (int i = 0; i < notes.length; i++) {
      noteString.add(notes[i].note);
      print(noteString[i]);
      color.add(notes[i].color);
      date.add(notes[i].captured);
      print(date[i]);
    }
    setState(() {
      loading = false;
    });
    print(notes);
  }

  double w, h;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF405CC7),
          title: Text(
            "My Notes",
            style: GoogleFonts.poppins(fontSize: 24, color: white),
          ),
          centerTitle: true,
        ),
        body: loading
            ? Center(
                child: SpinKitWanderingCubes(
                color: Colors.red,
                size: 20,
              ))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return card(index);
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getNotes(uid);
            navigateTo(context, AddNote());
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF48AAAD),
        ));
  }

  Widget card(int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: Card(
          color: Color(int.parse(color[index])),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          // shadowColor:
          child: Row(
            children: [
              SizedBox(width: 0.05 * w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    date[index],
                    style: GoogleFonts.poppins(fontSize: 20, color: white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: w * 0.6,
                    width: w * 0.4,
                    child: Text(
                      noteString[index],
                      style: GoogleFonts.poppins(fontSize: 16, color: white),
                    ),
                    // child: Image.network(image, fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
