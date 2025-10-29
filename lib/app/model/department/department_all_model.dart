// To parse this JSON data, do
//
//     final departmentAllModel = departmentAllModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'department_data.dart';

part 'department_all_model.g.dart';

DepartmentAllModel departmentAllModelFromJson(String str) => DepartmentAllModel.fromJson(json.decode(str));

String departmentAllModelToJson(DepartmentAllModel data) => json.encode(data.toJson());

@JsonSerializable()
class DepartmentAllModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  List<DepartmentData>? apiResult;

  DepartmentAllModel({this.status, this.msg, this.apiResult});

  factory DepartmentAllModel.fromJson(Map<String, dynamic> json) => _$DepartmentAllModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentAllModelToJson(this);
}
