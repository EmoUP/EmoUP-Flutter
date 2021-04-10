import 'package:emoup/Models/song.dart';
import 'package:emoup/Services/music.dart';
import 'package:emoup/const.dart';
import 'package:emoup/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicTherapy extends StatefulWidget {

  final String uid;
  MusicTherapy({this.uid});

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<MusicTherapy> {

  double h,w;
  List searchedList = [];
  List<Song> songs;
  bool loading = true;

  void initState() {
    super.initState();
    getEmotion();
  }

  getEmotion() async {
    songs = await getMusic(widget.uid);
    for(int i=0;i<songs.length;i++) {
      await fetchSongsList(i);
    }
    setState(() {
      loading = false;      
    });
  }

  void fetchSongsList(int index) async {
    String searchUrl = "https://www.jiosaavn.com/api.php?app_version=5.18.3&api_version=4&readable_version=5.18.3&v=79&_format=json&query=" +
      songs[index].spotifyName + "&__call=autocomplete.get";
    var res = await http.get(Uri.parse(searchUrl), headers: {"Accept": "application/json"});
    var resEdited = (res.body).split("-->");
    var getMain = json.decode(resEdited[1]);

    searchedList = getMain["songs"]["data"];
    for (int i = 0; i < searchedList.length; i++) {
      searchedList[i]['title'] = searchedList[i]['title']
          .toString()
          .replaceAll("&amp;", "&")
          .replaceAll("&#039;", "'")
          .replaceAll("&quot;", "\"");

      searchedList[i]['more_info']['singers'] = searchedList[i]['more_info']
              ['singers']
          .toString()
          .replaceAll("&amp;", "&")
          .replaceAll("&#039;", "'")
          .replaceAll("&quot;", "\"");
    }
    setState(() {
      searchedList = searchedList;
      songs[index].id = searchedList[0]["id"];
      songs[index].name = searchedList[0]["title"];
    });
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text(
          "Music",
          style: GoogleFonts.poppins(fontSize: 24, color: white),
        ),
        centerTitle: true,
      ),
      body: loading ? Center(
          child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Card(
              margin: EdgeInsets.only(bottom: 0.02 * h),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Card(
                  shadowColor: Color(0x80405CC7),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(songs[index].name)
                    ),
                    onTap: () {
                      navigateTo(context, Player(song: songs[index]));
                    },
                    subtitle: Text(songs[index].id),
                    trailing:  Icon(Icons.play_arrow),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  )
                );
              }
            ),
          ),
        ],
      )
    );
  }
}