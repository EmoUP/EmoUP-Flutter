class User {
  String name;
  String password;
  String birth;
  String profilePic;
  String deviceId;
  String email;

  User({
    this.name,
    this.password,
    this.birth,
    this.profilePic,
    this.deviceId,
    this.email
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
    birth = json['birth'];
    profilePic = json['profile_pic'];
    deviceId = json['device_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    data['birth'] = this.birth;
    data['profile_pic'] = this.profilePic;
    data['device_id'] = this.deviceId;
    data['email'] = this.email;
    return data;
  }
}