import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

MaterialColor egreen = MaterialColor(0xFF74B573, mapGen(0xFF74B573));
MaterialColor eblue = MaterialColor(0xFF2196F3, mapGen(0xFF2196F3));
MaterialColor eorange = MaterialColor(0xFFE4852C, mapGen(0xFFE4852C));
MaterialColor white = MaterialColor(0xFFFFFFFF, mapGen(0xFFFFFFFF));

mapGen(int color) {
  Map<int, Color> res = {
    50 : Color(color),
    100 : Color(color),
    200 : Color(color),
    300 : Color(color),
    400 : Color(color),
    500 : Color(color),
    600 : Color(color),
    700 : Color(color),
    800 : Color(color),
    900 : Color(color),
  };
  return res;
}

final server = "http://52.188.203.118:5000";

void navigateTo(BuildContext context, Widget destination) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
}

void navigateToPush(BuildContext context, Widget destination) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => destination));
}

final expression = "https://creator.us.uneeq.io/try/5cf70baa-a1f5-4d0a-833d-3f6de375bfe7";