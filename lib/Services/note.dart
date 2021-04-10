import 'package:emoup/Models/note.dart';
import 'package:emoup/const.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String> addNote(String note, String color, String uid) async {
  Uri url = Uri.parse(
      "http://52.188.203.118:5000" + "/users/add-note?user_id=" + uid);
  print(url);
  Response response = await post(url,
      headers: {"accept": "*/*", 'Content-Type': "application/json"},
      body: jsonEncode({
        "note": note,
        "color": color,
        "captured": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
      }));
  dynamic data = jsonDecode(response.body);
  if (response.statusCode == 200 || response.statusCode == 201)
    return "";
  else {
    print(response.statusCode);
    return "";
  }
}

Future<List<Notes>> getNotes(String uid) async {
  Uri url = Uri.parse("http://52.188.203.118:5000" + "/users/" + uid);
  Response response = await get(
    url,
    headers: {"Accept": "application/json", "Connection": "Keep-Alive"},
  );
  // Map<String, dynamic> map = json.decode(response.body);
  // List<dynamic> data = map["notes"];
  // dynamic data = json.decode(response.body);
  dynamic data = json.decode(response.body)["notes"];
  List<Notes> notes = [];

  for (int i = 0; i < data.length; i++) {
    // notes.add(data[i]);
    print(data[i].toString());
    notes.add(Notes.fromJson(data[i]));
  }
  print(notes);
  return notes;
}
