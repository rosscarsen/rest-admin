// To parse this JSON data, do
//
//     final payMethodAllModel = payMethodAllModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'pay_method_data.dart';

part 'pay_method_all_model.g.dart';

PayMethodAllModel payMethodAllModelFromJson(String str) => PayMethodAllModel.fromJson(json.decode(str));

String payMethodAllModelToJson(PayMethodAllModel data) => json.encode(data.toJson());

@JsonSerializable()
class PayMethodAllModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final List<PayMethodData>? apiResult;

  PayMethodAllModel({this.status, this.msg, this.apiResult});

  PayMethodAllModel copyWith({int? status, String? msg, List<PayMethodData>? apiResult}) =>
      PayMethodAllModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory PayMethodAllModel.fromJson(Map<String, dynamic> json) => _$PayMethodAllModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayMethodAllModelToJson(this);
}
