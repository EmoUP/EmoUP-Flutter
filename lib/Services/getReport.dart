import 'dart:convert';
import 'package:emoup/OnBoarding/chartData.dart';
import 'package:emoup/const.dart';
import 'package:http/http.dart';

Future<List<dynamic>> getReport(String uid) async {
  Uri url = Uri.parse(server + "/users/emotion-analysis/" + uid);
  Response response = await get(
    url,
    headers: {
      "Accept": "application/json", 
      "Connection": "Keep-Alive"
    },
  );
  dynamic res = json.decode(response.body);
  dynamic data = res["emotion"];
  print(data.length);
  List<dynamic> lst = [];
  List<ChartData> report = [];
  if(data["happy"] != null) {
    report.add(new ChartData("Happy", data["happy"]));
  }
  if(data["fear"] != null) {
    report.add(new ChartData("Fear", data["fear"]));
  }
  if(data["surprise"] != null) {
    report.add(new ChartData("Surprise", data["surprise"]));
  }
  if(data["sad"] != null) {
    report.add(new ChartData("Sad", data["sad"]));
  }
  if(data["neutral"] != null) {
    report.add(new ChartData("Neutral", data["neutral"]));
  }
  if(data["angry"] != null) {
    report.add(new ChartData("Angry", data["angry"]));
  }
  lst.add(report);
  lst.add(res["wordcloud"]);
  return lst;
}