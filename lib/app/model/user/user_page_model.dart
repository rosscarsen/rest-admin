// To parse this JSON data, do
//
//     final userPageModel = userPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'user_data.dart';

part 'user_page_model.g.dart';

UserPageModel userPageModelFromJson(String str) => UserPageModel.fromJson(json.decode(str));

String userPageModelToJson(UserPageModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class UserPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  UserPageResult? apiResult;

  UserPageModel({this.status, this.msg, this.apiResult});

  factory UserPageModel.fromJson(Map<String, dynamic> json) => _$UserPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPageModelToJson(this);
}

@JsonSerializable()
class UserPageResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<UserData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  UserPageResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  factory UserPageResult.fromJson(Map<String, dynamic> json) => _$UserPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$UserPageResultToJson(this);
}
