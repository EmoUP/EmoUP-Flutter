import 'dart:convert';
import 'package:emoup/Models/song.dart';
import 'package:emoup/const.dart';
import 'package:http/http.dart';

Future<List<Song>> getMusic(String uid) async {
  Uri url = Uri.parse(server + "/therapies/music-recommendation/" + uid);
  Response response = await get(
    url,
    headers: {
      "Accept": "application/json", 
      "Connection": "Keep-Alive"
    },
  );
  dynamic data = json.decode(response.body)["songs"];
  List<Song> music = [];
  for (int i = 0; i < data.length; i++) {
    music.add(Song.fromJson(data[i]));
  }
  return music;
}
