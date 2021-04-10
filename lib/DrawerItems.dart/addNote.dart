import 'package:emoup/Services/note.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

double w, h;
const List<ColorSwatch> color = [
  Colors.red,
  Colors.yellow,
  Colors.blueAccent,
  Colors.green,
  Colors.orange,
  Colors.purple,
];

class _AddNoteState extends State<AddNote> {
  String uid;
  SharedPreferences prefs;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  initState() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid");
  }

  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF405CC7),
          title: Text(
            "Add Note",
            style: GoogleFonts.poppins(fontSize: 24, color: white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Card(
                  margin: EdgeInsets.only(bottom: 0.02 * h),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child:
                      Image.asset("assets/images/header.png", fit: BoxFit.fill),
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: w,
                    height: h,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                        child: Card(
                          color: currentColor,
                          margin: EdgeInsets.only(bottom: 0.02 * h),
                          elevation: 5,
                          shadowColor: eblue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: textController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add Note",
                                ),
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                maxLines: 15,
                              ),
                            ),
                          ),
                        )),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 0.8 * h,
                        width: 0.5 * w,
                      ),
                      RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Text("Pick"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Pick a color!'),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                      showLabel: true,
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: const Text('Select'),
                                      onPressed: () {
                                        setState(
                                            () => currentColor = pickerColor);
                                        Navigator.of(context).pop();
                                        print(currentColor);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: h * 0.1,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(currentColor);
            print(uid);

            // await addNote(
            //     textController.text, currentColor.value.toString(), uid);
            await getNotes(uid);
          },
          child: Icon(Icons.check),
          backgroundColor: eblue,
        ));
  }

  colorPicker() {}
}
