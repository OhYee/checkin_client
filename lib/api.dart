import 'dart:ffi';

import 'package:flutter/material.dart';
import 'utils.dart';

class LoginResponse {
  String token;

  LoginResponse({this.token: ""});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}

Future<LoginResponse> login(
  BuildContext context,
  String username,
  String password,
) async {
  LoginResponse res = LoginResponse();
  try {
    res = LoginResponse.fromJson(
      await requestGet("/login", {"username": username, "password": password}),
    );
  } catch (e) {
    makeToast(context: context, text: e.toString());
  }
  return res;
}

class LogoutResponse {
  bool success;

  LogoutResponse({this.success: false});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  }
}

Future<LogoutResponse> logout(
  BuildContext context,
  String token,
) async {
  LogoutResponse res = LogoutResponse();
  try {
    res = LogoutResponse.fromJson(
      await requestGet("/get", {"token": token}),
    );
  } catch (e) {
    makeToast(context: context, text: e.toString());
  }
  return res;
}

class GetResponse {
  int money;
  int weight;
  String note;

  GetResponse({this.money: -1, this.weight: 0, this.note});

  GetResponse.fromJson(Map<String, dynamic> json) {
    money = json['money'];
    weight = json['weight'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['money'] = this.money;
    data['weight'] = this.weight;
    data['note'] = this.note;
    return data;
  }
}

Future<GetResponse> getData(
  BuildContext context,
  int date,
  String token,
) async {
  GetResponse res = GetResponse();
  try {
    res = GetResponse.fromJson(
      await requestGet("/get", {"date": date.toString(), "token": token}),
    );
  } catch (e) {
    makeToast(context: context, text: e.toString());
  }
  return res;
}

class SetResponse {
  bool success = false;

  SetResponse({this.success: false});

  SetResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  }
}

Future<SetResponse> setData(
  BuildContext context,
  int date,
  String token,
  int weight,
  String note,
) async {
  SetResponse res = SetResponse();
  try {
    res = SetResponse.fromJson(
      await requestPost("/set", {
        "date": date,
        "token": token,
        "weight": weight,
        "note": note,
      }),
    );
  } catch (e) {
    makeToast(context: context, text: e.toString());
  }
  return res;
}

class InfoResponse {
  int money;
  int day;
  int lottery;

  InfoResponse({this.money: 0, this.day: 0, this.lottery: 0});

  InfoResponse.fromJson(Map<String, dynamic> json) {
    money = json['money'];
    day = json['day'];
    lottery = json['lottery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['money'] = this.money;
    data['day'] = this.day;
    data['lottery'] = this.lottery;
    return data;
  }
}

Future<InfoResponse> info(
  BuildContext context,
  String token,
) async {
  InfoResponse res = InfoResponse();
  try {
    res = InfoResponse.fromJson(
      await requestGet("/info", {
        "token": token,
      }),
    );
  } catch (e) {
    makeToast(context: context, text: e.toString());
  }
  return res;
}

class CheckInResponse {
  int money;
  int day;
  int lottery;

  CheckInResponse({this.money: 0, this.day: 0, this.lottery: 0});

  CheckInResponse.fromJson(Map<String, dynamic> json) {
    money = json['money'];
    day = json['day'];
    lottery = json['lottery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['money'] = this.money;
    data['day'] = this.day;
    data['lottery'] = this.lottery;
    return data;
  }
}

Future<CheckInResponse> checkIn(
  BuildContext context,
  int date,
  String token,
) async {
  CheckInResponse res = CheckInResponse();
  try {
    res = CheckInResponse.fromJson(
      await requestGet("/checkin", {
        "date": date.toString(),
        "token": token,
      }),
    );
  } catch (e) {
    makeToast(context: context, text: e.toString());
  }
  return res;
}
