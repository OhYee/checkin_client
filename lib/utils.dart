import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const title = "checkin!";
const url = "192.168.1.6";
const prefix = "/api/checkin";

class Data {
  int weight = 0;
  String note = "";
  int money = -1;
  Data({this.weight, this.note, this.money});
}

String dateToString(DateTime datetime) {
  return "${datetime.year}-${datetime.month}-${datetime.day}";
}

String datetimeToString(DateTime datetime) {
  return "${datetime.year}-${datetime.month}-${datetime.day} ${datetime.hour}:${datetime.minute}:${datetime.second}";
}

bool isToday(DateTime datetime) {
  DateTime now = DateTime.now();
  return now.year == datetime.year &&
      now.month == datetime.month &&
      now.day == datetime.day;
}

class Visiable extends StatelessWidget {
  final bool show;
  final Widget child;
  Visiable({Key key, this.show, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return show ? child : Container();
  }
}

Future<dynamic> request(String api, Map<String, String> params) async {
  var httpClient = new HttpClient();
  var uri = new Uri.http(url, prefix + api, params);
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  Map data = json.decode(responseBody);
  return data;
}

makeToast({
  @required BuildContext context,
  @required String text,
  String action,
  Function callback,
}) {
  // hide the last snackbar
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(text),
    action: action != null
        ? SnackBarAction(
            label: action,
            onPressed: () => callback == null
                ? Scaffold.of(context).hideCurrentSnackBar()
                : callback,
          )
        : null,
  ));
}

Future<String> getValue(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String value = preferences.get(key);
  return value;
}

Future<bool> setValue(String key, String value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString(key, value);
}

Future<bool> delValue(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.remove(key);
}
