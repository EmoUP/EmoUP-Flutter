// To parse this JSON data, do
//
//     final notes = notesFromJson(jsonString);

import 'dart:convert';

List<Notes> notesFromJson(String str) =>
    List<Notes>.from(json.decode(str).map((x) => Notes.fromJson(x)));

String notesToJson(List<Notes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notes {
  Notes({
    this.note,
    this.color,
    this.captured,
  });

  String note;
  String color;
  String captured;

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        note: json["note"],
        color: json["color"],
        captured: json["captured"],
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "color": color,
        "captured": captured,
      };
}
