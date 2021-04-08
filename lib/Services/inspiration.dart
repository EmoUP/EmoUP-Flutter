import 'dart:convert';
import 'package:emoup/const.dart';
import 'package:http/http.dart';

Future<List<String>> getImages(String uid) async {
  Uri url = Uri.parse(server + "/therapies/inspiration/" + uid);
  Response response = await get(
    url,
    headers: {
      "Accept": "application/json", 
      "Connection": "Keep-Alive"
    },
  );
  dynamic data = json.decode(response.body);
  List<String> images = [];
  for (int i = 0; i < data['quotes'].length; i++) {
    images.add(data['quotes'][i].toString());
  }
  return images;
}
