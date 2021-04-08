import 'dart:convert';
import 'package:http/http.dart';
import 'package:emoup/Models/Doctor.dart';
import 'package:emoup/const.dart';

Future<List<Doctor>> getDoctors() async {
  Uri url = Uri.parse(server+"/doctors");
  Response response = await get(
    url,
    headers: {"Accept": "application/json", "Connection": "Keep-Alive"},
  );
  dynamic data = json.decode(response.body);
  List<Doctor> ret = [];
  for (int i = 0; i < data.length; i++) {
    Doctor doc = Doctor.fromJson(data[i]);
    ret.add(doc);
  }
  return ret;
}