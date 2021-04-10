class People {
  String name;
  String profilePic;
  String uid;

  People({this.name, this.profilePic, this.uid});

  People.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePic = json['profile_pic'];
    uid = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['user_id'] = this.uid;
    return data;
  }
}