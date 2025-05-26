// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  UserData? data;
  String? msg;
  int? status;

  LoginModel({this.data, this.msg, this.status});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    data: json["data"] == null ? null : UserData.fromJson(json["data"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "msg": msg, "status": status};

  @override
  String toString() => 'LoginModel(data: $data, msg: $msg, status: $status)';
}

class UserData {
  String? company;
  String? pwd;
  String? user;
  Dsn? dsn;

  UserData({this.company, this.pwd, this.user, this.dsn});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    company: json["company"],
    pwd: json["pwd"],
    user: json["user"],
    dsn: json["dsn"] == null ? null : Dsn.fromJson(json["dsn"]),
  );

  Map<String, dynamic> toJson() => {"company": company, "pwd": pwd, "user": user, "dsn": dsn?.toJson()};

  @override
  String toString() {
    return 'UserData(company: $company, pwd: $pwd, user: $user, dsn: $dsn)';
  }
}

class Dsn {
  String? type;
  String? hostname;
  String? database;
  String? username;
  String? password;
  int? hostport;
  String? charset;
  String? prefix;

  Dsn({
    this.type,
    this.hostname,
    this.database,
    this.username,
    this.password,
    this.hostport,
    this.charset,
    this.prefix,
  });

  factory Dsn.fromJson(Map<String, dynamic> json) => Dsn(
    type: json["type"],
    hostname: json["hostname"],
    database: json["database"],
    username: json["username"],
    password: json["password"],
    hostport: json["hostport"],
    charset: json["charset"],
    prefix: json["prefix"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "hostname": hostname,
    "database": database,
    "username": username,
    "password": password,
    "hostport": hostport,
    "charset": charset,
    "prefix": prefix,
  };

  @override
  String toString() {
    return 'Dsn(type: $type, hostname: $hostname, database: $database, username: $username, password: $password, hostport: $hostport, charset: $charset, prefix: $prefix)';
  }
}
