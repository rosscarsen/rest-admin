// To parse this JSON data, do
//
//     final payMethodPageModel = payMethodPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'pay_method_data.dart';

part 'pay_method_page_model.g.dart';

PayMethodPageModel payMethodPageModelFromJson(String str) => PayMethodPageModel.fromJson(json.decode(str));

String payMethodPageModelToJson(PayMethodPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class PayMethodPageModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final PayMethodResult? apiResult;

  PayMethodPageModel({this.status, this.msg, this.apiResult});

  PayMethodPageModel copyWith({int? status, String? msg, PayMethodResult? apiResult}) =>
      PayMethodPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory PayMethodPageModel.fromJson(Map<String, dynamic> json) => _$PayMethodPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayMethodPageModelToJson(this);
}

@JsonSerializable()
class PayMethodResult {
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "current_page")
  final int? currentPage;
  @JsonKey(name: "last_page")
  final int? lastPage;
  @JsonKey(name: "data")
  final List<PayMethodData>? data;
  @JsonKey(name: "has_more")
  final bool? hasMore;

  PayMethodResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  PayMethodResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<PayMethodData>? data,
    bool? hasMore,
  }) => PayMethodResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory PayMethodResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}
