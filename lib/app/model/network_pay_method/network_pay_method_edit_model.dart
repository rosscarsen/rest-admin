// To parse this JSON data, do
//
//     final networkPayMethodEditModel = networkPayMethodEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'network_pay_method_data.dart';

part 'network_pay_method_edit_model.g.dart';

NetworkPayMethodEditModel networkPayMethodEditModelFromJson(String str) =>
    NetworkPayMethodEditModel.fromJson(json.decode(str));

String networkPayMethodEditModelToJson(NetworkPayMethodEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class NetworkPayMethodEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  NetworkPayMethodData? apiResult;

  NetworkPayMethodEditModel({this.status, this.msg, this.apiResult});

  factory NetworkPayMethodEditModel.fromJson(Map<String, dynamic> json) => _$NetworkPayMethodEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkPayMethodEditModelToJson(this);
}
