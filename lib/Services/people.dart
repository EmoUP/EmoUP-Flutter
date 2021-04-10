import 'dart:convert';
import 'package:emoup/Models/people.dart';
import 'package:http/http.dart';
import 'package:emoup/const.dart';

Future<List<People>> getPeople() async {
  Uri url = Uri.parse(server+"/users");
  Response response = await get(
    url,
    headers: {"Accept": "application/json", "Connection": "Keep-Alive"},
  );
  dynamic data = json.decode(response.body);
  List<People> ret = [];
  for (int i = 0; i < data.length; i++) {
    People peep = People.fromJson(data[i]);
    ret.add(peep);
  }
  return ret;
}