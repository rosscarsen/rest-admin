// To parse this JSON data, do
//
//     final departmentEditModel = departmentEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'department_data.dart';

part 'department_edit_model.g.dart';

DepartmentEditModel departmentEditModelFromJson(String str) => DepartmentEditModel.fromJson(json.decode(str));

String departmentEditModelToJson(DepartmentEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class DepartmentEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  DepartmentData? apiResult;

  DepartmentEditModel({this.status, this.msg, this.apiResult});

  factory DepartmentEditModel.fromJson(Map<String, dynamic> json) => _$DepartmentEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentEditModelToJson(this);
}
