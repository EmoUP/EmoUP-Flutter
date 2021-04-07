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

completeProfile(User user, String uid) async {
  Uri url = Uri.parse(server+"/users/"+uid);
  Response res = await patch(
    url,
    headers: {
      "accept": "*/*",
      'Content-Type': "application/json"
    },
    body: jsonEncode({
      "name": user.name,
      "birth": user.birth
    })
  );
  print("comp"+res.statusCode.toString());
}

uploadPfp(PlatformFile pfp, String uid) async {
  var request = MultipartRequest('POST', Uri.parse(server + "/users/add-profile-pic?user_id=" + uid));
  File compressed = await compressAndGetFile(File(pfp.path), pfp.path.replaceAll(pfp.name.split(".")[0], pfp.name.split(".")[0]+"-comp"));
  request.files.add(
    MultipartFile(
      'picture',
      compressed.readAsBytes().asStream(),
      compressed.lengthSync(),
      filename: pfp.name
    )
  );
  var res = await request.send();
  print(res.statusCode);
}

Future<File> compressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, targetPath,
    quality: 50,
  );
  return result;
}

setUser(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(uid != "")
    prefs.setString("uid", uid);
  else
    prefs.remove("email");
}