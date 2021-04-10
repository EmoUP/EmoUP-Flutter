import 'package:audio_session/audio_session.dart';
import 'package:emoup/Models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:emoup/Widgets/ControlButtons.dart';
import 'package:emoup/Widgets/SeekBar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:emoup/const.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:des_plugin/des_plugin.dart';
import 'dart:convert';

class Player extends StatefulWidget {

  final Song song;
  Player({this.song});

  @override
  _PlayerSetup createState() => _PlayerSetup();
}

class AudioMetadata {
  String album;
  String title;
  String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}

class _PlayerSetup extends State<Player> {
  AudioPlayer _player;
  var _playlist;
  
  var credentials;
  var spotify;
  bool loaded = false;
  String kUrl = "";
  String key = "38346591";
  AudioMetadata meta = new AudioMetadata();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }
  
  Future<void> _init() async {
    
    List<AudioSource> playlist = [];
    playlist.add(AudioSource.uri(
      Uri.parse(await fetchSongDetails(widget.song.id)),
      tag: meta
    ));
    _playlist = ConcatenatingAudioSource(children: playlist);
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }

    setState(() {
      loaded = true;
    });
  }

  Future fetchSongDetails(songId) async {
    String songUrl = "https://www.jiosaavn.com/api.php?app_version=5.18.3&api_version=4&readable_version=5.18.3&v=79&_format=json&__call=song.getDetails&pids=" + songId;
    var res = await http.get(Uri.parse(songUrl), headers: {"Accept": "application/json"});
    var resEdited = (res.body).split("-->");
    var getMain = json.decode(resEdited[1]);

    meta.title = (getMain[songId]["title"])
      .toString()
      .split("(")[0]
      .replaceAll("&amp;", "&")
      .replaceAll("&#039;", "'")
      .replaceAll("&quot;", "\"");
    meta.artwork = (getMain[songId]["image"]).replaceAll("150x150", "500x500");
    meta.album = (getMain[songId]["more_info"]["album"])
      .toString()
      .replaceAll("&quot;", "\"")
      .replaceAll("&#039;", "'")
      .replaceAll("&amp;", "&");

    kUrl = await DesPlugin.decrypt(key, getMain[songId]["more_info"]["encrypted_media_url"]);
    final client = http.Client();
    final request = http.Request('HEAD', Uri.parse(kUrl))
      ..followRedirects = false;
    final response = await client.send(request);
    kUrl = (response.headers['location']);
    return kUrl;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: SwipeDetector(
        onSwipeDown: () {
          if (_player.hasPrevious)
            _player.seekToPrevious();
        },
        onSwipeUp: () {
          if (_player.hasNext)
            _player.seekToNext();
        },
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: height*0.1,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/music.png"), fit: BoxFit.fitHeight)
          ),
          child: loaded ? SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<SequenceState>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state == null) 
                        return Image.asset("assets/images/music.png");
                      final metadata = state.currentSource.tag as AudioMetadata;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "NOW PLAYING",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24
                            )
                          ),
                          Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 0.05 * height),
                            elevation: 5,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              radius: 0.15 * height,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                metadata.artwork,
                              ),
                            ),
                          ),  
                          Text(metadata.title,
                              style: Theme.of(context).textTheme.headline6),
                          Text(metadata.album),
                          SizedBox(
                            height: 0.1 * height,
                          ),
                          StreamBuilder<Duration>(
                            stream: _player.durationStream,
                            builder: (context, snapshot) {
                              final duration = snapshot.data ?? Duration.zero;
                              return StreamBuilder<PositionData>(
                                stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                                    _player.positionStream,
                                    _player.bufferedPositionStream,
                                    (position, bufferedPosition) =>
                                        PositionData(position, bufferedPosition)),
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data ??
                                      PositionData(Duration.zero, Duration.zero);
                                  var position = positionData.position;
                                  if (position > duration) {
                                    position = duration;
                                  }
                                  var bufferedPosition = positionData.bufferedPosition;
                                  if (bufferedPosition > duration) {
                                    bufferedPosition = duration;
                                  }
                                  return SeekBar(
                                    duration: duration,
                                    position: position,
                                    bufferedPosition: bufferedPosition,
                                    onChangeEnd: (newPosition) {
                                      _player.seek(newPosition);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: ControlButtons(_player)
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ) : SpinKitWave(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}