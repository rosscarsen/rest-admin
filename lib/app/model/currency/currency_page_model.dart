// To parse this JSON data, do
//
//     final currencyPageModel = currencyPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'currency_data.dart';

part 'currency_page_model.g.dart';

CurrencyPageModel currencyPageModelFromJson(String str) => CurrencyPageModel.fromJson(json.decode(str));

String currencyPageModelToJson(CurrencyPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class CurrencyPageModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final CurrencyResult? apiResult;

  CurrencyPageModel({this.status, this.msg, this.apiResult});

  CurrencyPageModel copyWith({int? status, String? msg, CurrencyResult? apiResult}) =>
      CurrencyPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory CurrencyPageModel.fromJson(Map<String, dynamic> json) => _$CurrencyPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyPageModelToJson(this);
}

@JsonSerializable()
class CurrencyResult {
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "current_page")
  final int? currentPage;
  @JsonKey(name: "last_page")
  final int? lastPage;
  @JsonKey(name: "data")
  final List<CurrencyData>? data;
  @JsonKey(name: "has_more")
  final bool? hasMore;

  CurrencyResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  CurrencyResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<CurrencyData>? data,
    bool? hasMore,
  }) => CurrencyResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory CurrencyResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}
