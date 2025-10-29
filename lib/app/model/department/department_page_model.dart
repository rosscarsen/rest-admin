// To parse this JSON data, do
//
//     final departmentPageModel = departmentPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'department_data.dart';

part 'department_page_model.g.dart';

DepartmentPageModel departmentPageModelFromJson(String str) => DepartmentPageModel.fromJson(json.decode(str));

String departmentPageModelToJson(DepartmentPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class DepartmentPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  ApiResult? apiResult;

  DepartmentPageModel({this.status, this.msg, this.apiResult});

  factory DepartmentPageModel.fromJson(Map<String, dynamic> json) => _$DepartmentPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentPageModelToJson(this);
}

@JsonSerializable()
class ApiResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<DepartmentData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  factory ApiResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}
