import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTherapy extends StatefulWidget {

  final String uid;
  VideoTherapy({this.uid});
  @override
  _VideoTherapyState createState() => _VideoTherapyState();
}

class _VideoTherapyState extends State<VideoTherapy> {
 
  bool loading = true;
  double w, h;

  @override
  void initState() {
    super.initState();
  }

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'p-7KHufWYVQ',
);

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: YoutubePlayer(
        controller: _controller,
      ),
    );
  }
}