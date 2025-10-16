// To parse this JSON data, do
//
//     final stockPageModel = stockPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'stock_data.dart';

part 'stock_page_model.g.dart';

StockPageModel stockPageModelFromJson(String str) => StockPageModel.fromJson(json.decode(str));

String stockPageModelToJson(StockPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class StockPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  StockApiResult? apiResult;

  StockPageModel({this.status, this.msg, this.apiResult});

  StockPageModel copyWith({int? status, String? msg, StockApiResult? apiResult}) =>
      StockPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory StockPageModel.fromJson(Map<String, dynamic> json) => _$StockPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockPageModelToJson(this);
}

@JsonSerializable()
class StockApiResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<StockData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  StockApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  StockApiResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<StockData>? data,
    bool? hasMore,
  }) => StockApiResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory StockApiResult.fromJson(Map<String, dynamic> json) => _$StockApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$StockApiResultToJson(this);
}
