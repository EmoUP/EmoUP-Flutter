class Song{
  String name;
  String id;
  String spotifyName;
  String spotifyId;
  int numberOfLikes;

  Song({this.name, this.spotifyId, this.numberOfLikes});

  Song.fromJson(Map<String, dynamic> json) {
    spotifyName = json['name'];
    spotifyId = json['spotify_id'];
    numberOfLikes = json['number_of_likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.spotifyName;
    data['spotify_id'] = this.spotifyId;
    data['number_of_likes'] = this.numberOfLikes;
    return data;
  }
}