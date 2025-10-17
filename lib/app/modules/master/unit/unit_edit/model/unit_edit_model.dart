// To parse this JSON data, do
//
//     final unitEditModel = unitEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../../../model/unit/unit_data.dart';

part 'unit_edit_model.g.dart';

UnitEditModel unitEditModelFromJson(String str) => UnitEditModel.fromJson(json.decode(str));

String unitEditModelToJson(UnitEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class UnitEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  UnitData? apiResult;

  UnitEditModel({this.status, this.msg, this.apiResult});

  UnitEditModel copyWith({int? status, String? msg, UnitData? apiResult}) =>
      UnitEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory UnitEditModel.fromJson(Map<String, dynamic> json) => _$UnitEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitEditModelToJson(this);
}
