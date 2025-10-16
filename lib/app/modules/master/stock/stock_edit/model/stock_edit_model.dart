// To parse this JSON data, do
//
//     final stockEditModel = stockEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../../../model/stock/stock_data.dart';

part 'stock_edit_model.g.dart';

StockEditModel stockEditModelFromJson(String str) => StockEditModel.fromJson(json.decode(str));

String stockEditModelToJson(StockEditModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class StockEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  StockData? apiResult;

  StockEditModel({this.status, this.msg, this.apiResult});

  StockEditModel copyWith({int? status, String? msg, StockData? apiResult}) =>
      StockEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory StockEditModel.fromJson(Map<String, dynamic> json) => _$StockEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockEditModelToJson(this);
}
