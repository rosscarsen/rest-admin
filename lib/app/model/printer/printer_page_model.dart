// To parse this JSON data, do
//
//     final printerPageModel = printerPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'printer_data.dart';

part 'printer_page_model.g.dart';

PrinterPageModel printerPageModelFromJson(String str) => PrinterPageModel.fromJson(json.decode(str));

String printerPageModelToJson(PrinterPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class PrinterPageModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final ApiResult? apiResult;

  PrinterPageModel({this.status, this.msg, this.apiResult});

  PrinterPageModel copyWith({int? status, String? msg, ApiResult? apiResult}) =>
      PrinterPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory PrinterPageModel.fromJson(Map<String, dynamic> json) => _$PrinterPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterPageModelToJson(this);
}

@JsonSerializable()
class ApiResult {
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "current_page")
  final int? currentPage;
  @JsonKey(name: "last_page")
  final int? lastPage;
  @JsonKey(name: "data")
  final List<PrinterData>? data;
  @JsonKey(name: "has_more")
  final bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  ApiResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<PrinterData>? data,
    bool? hasMore,
  }) => ApiResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory ApiResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}
