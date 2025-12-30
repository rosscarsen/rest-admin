// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'login_model.g.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class LoginModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final LoginResult? apiResult;

  LoginModel({this.status, this.msg, this.apiResult});

  LoginModel copyWith({int? status, String? msg, LoginResult? apiResult}) =>
      LoginModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LoginResult {
  @JsonKey(name: "company")
  final String? company;
  @JsonKey(name: "pwd")
  final String? pwd;
  @JsonKey(name: "user")
  final String? user;
  @JsonKey(name: "dsn")
  final Dsn? dsn;
  @JsonKey(name: "aesKey")
  final String aesKey;

  LoginResult({this.company, this.pwd, this.user, this.dsn, required this.aesKey});

  LoginResult copyWith({String? company, String? pwd, String? user, Dsn? dsn, String? aesKey}) => LoginResult(
    company: company ?? this.company,
    pwd: pwd ?? this.pwd,
    user: user ?? this.user,
    dsn: dsn ?? this.dsn,
    aesKey: aesKey ?? this.aesKey,
  );

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Dsn {
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "hostname")
  final String? hostname;
  @JsonKey(name: "database")
  final String? database;
  @JsonKey(name: "username")
  final String? username;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "hostport")
  final int? hostport;
  @JsonKey(name: "charset")
  final String? charset;
  @JsonKey(name: "prefix")
  final String? prefix;

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

  Dsn copyWith({
    String? type,
    String? hostname,
    String? database,
    String? username,
    String? password,
    int? hostport,
    String? charset,
    String? prefix,
  }) => Dsn(
    type: type ?? this.type,
    hostname: hostname ?? this.hostname,
    database: database ?? this.database,
    username: username ?? this.username,
    password: password ?? this.password,
    hostport: hostport ?? this.hostport,
    charset: charset ?? this.charset,
    prefix: prefix ?? this.prefix,
  );

  factory Dsn.fromJson(Map<String, dynamic> json) => _$DsnFromJson(json);

  Map<String, dynamic> toJson() => _$DsnToJson(this);
}
