// To parse this JSON data, do
//
//     final currencyAllModel = currencyAllModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'currency_data.dart';

part 'currency_all_model.g.dart';

CurrencyAllModel currencyAllModelFromJson(String str) => CurrencyAllModel.fromJson(json.decode(str));

String currencyAllModelToJson(CurrencyAllModel data) => json.encode(data.toJson());

@JsonSerializable()
class CurrencyAllModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final List<CurrencyData>? apiResult;

  CurrencyAllModel({this.status, this.msg, this.apiResult});

  CurrencyAllModel copyWith({int? status, String? msg, List<CurrencyData>? apiResult}) =>
      CurrencyAllModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory CurrencyAllModel.fromJson(Map<String, dynamic> json) => _$CurrencyAllModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyAllModelToJson(this);
}
