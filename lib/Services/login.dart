import 'dart:convert';
import 'package:emoup/const.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> createUser(LoginData loginData) async {
  Uri url = Uri.parse(server+"/users");
  print(url);
  Response response = await post(
    url,
    headers: {
      "accept": "*/*",
      'Content-Type': "application/json"
    },
    body: jsonEncode({
      "email": loginData.name,
      "password": loginData.password
    })
  );
  dynamic data = jsonDecode(response.body);
  setUser(data["user_id"]);
  return "";
}

Future<String> login(LoginData loginData) async {
  Uri url = Uri.parse(server+"/users/login?email="+loginData.name+"&password="+loginData.password);
  print(url);
  Response response = await post(
    url,
    headers: {
      "accept": "*/*",
      'Content-Type': "application/json"
    }
  );
  dynamic data = jsonDecode(response.body);
  if(data["status"] == true) {
    setUser(data["_id"]);
    return "";
  } else {
    return data["message"];
  }
}

setUser(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(uid != "")
    prefs.setString("uid", uid);
  else
    prefs.remove("email");
}