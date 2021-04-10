import 'dart:convert';
import 'dart:io';
import 'package:emoup/Models/user.dart';
import 'package:emoup/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String> createUser(LoginData loginData) async {
  Uri url = Uri.parse(server + "/users");
  print(url);
  Response response = await post(url,
      headers: {"accept": "*/*", 'Content-Type': "application/json"},
      body: jsonEncode(
          {"email": loginData.name, "password": loginData.password}));
  dynamic data = jsonDecode(response.body);
  setUser("uid", data["user_id"]);
  return "";
}

Future<String> login(LoginData loginData) async {
  Uri url = Uri.parse("http://52.188.203.118:5000" +
      "/users/login?email=" +
      loginData.name +
      "&password=" +
      loginData.password);
  print(url);
  Response response = await post(url,
      headers: {"accept": "*/*", 'Content-Type': "application/json"});
  dynamic data = jsonDecode(response.body);
  if (data["status"] == true) {
    setUser("uid", data["_id"]);
    return "";
  } else {
    return data["message"];
  }
}

completeProfile(User user, String uid) async {
  Uri url = Uri.parse(server + "/users/" + uid);
  Response res = await patch(url,
      headers: {"accept": "*/*", 'Content-Type': "application/json"},
      body: jsonEncode({"name": user.name, "birth": user.birth}));
  setUser("name", user.name);
}

uploadPfp(PlatformFile pfp, String uid) async {
  var request = MultipartRequest(
      'POST', Uri.parse(server + "/users/add-profile-pic?user_id=" + uid));
  File compressed = await compressAndGetFile(
      File(pfp.path),
      pfp.path.replaceAll(
          pfp.name.split(".")[0], pfp.name.split(".")[0] + "-comp"));
  request.files.add(MultipartFile(
      'picture', compressed.readAsBytes().asStream(), compressed.lengthSync(),
      filename: pfp.name));
  var res = await request.send();
  print(res.statusCode);
}

Future<File> compressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 50,
  );
  return result;
}

linkDevice(String device, String uid) async {
  Uri url = Uri.parse(server + "/users/" + uid);
  Response res = await patch(url,
      headers: {"accept": "*/*", 'Content-Type': "application/json"},
      body: jsonEncode({"device_id": device}));
}

Future<User> getUserInfo(String uid) async {
  Uri url = Uri.parse(server + "/users/" + uid);
  Response res = await get(
    url,
    headers: {"accept": "*/*", 'Content-Type': "application/json"},
  );
  return User.fromJson(jsonDecode(res.body));
}

Future<List<User>> getUsers() async {
  Uri url = Uri.parse("http://52.188.203.118:5000" + "/users");
  Response res = await get(url,
      headers: {"accept": "*/*", 'Content-Type': "application/json"});
  dynamic data = json.decode(res.body);
  List<User> users = [];
  for (int i = 0; i < data.length; i++) {
    users.add(data[i]);
    print(data);
  }
  return users;
}

setUser(String param, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(param, value);
}
