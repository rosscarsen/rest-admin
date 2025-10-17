// To parse this JSON data, do
//
//     final currencyEditModel = currencyEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../../../model/currency/currency_data.dart';

part 'currency_edit_model.g.dart';

CurrencyEditModel currencyEditModelFromJson(String str) => CurrencyEditModel.fromJson(json.decode(str));

String currencyEditModelToJson(CurrencyEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class CurrencyEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  CurrencyData? apiResult;

  CurrencyEditModel({this.status, this.msg, this.apiResult});

  CurrencyEditModel copyWith({int? status, String? msg, CurrencyData? apiResult}) =>
      CurrencyEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory CurrencyEditModel.fromJson(Map<String, dynamic> json) => _$CurrencyEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyEditModelToJson(this);
}
