// To parse this JSON data, do
//
//     final unitPageModel = unitPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'unit_data.dart';

part 'unit_page_model.g.dart';

UnitPageModel unitPageModelFromJson(String str) => UnitPageModel.fromJson(json.decode(str));

String unitPageModelToJson(UnitPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class UnitPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  UnitApiResult? apiResult;

  UnitPageModel({this.status, this.msg, this.apiResult});

  UnitPageModel copyWith({int? status, String? msg, UnitApiResult? apiResult}) =>
      UnitPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory UnitPageModel.fromJson(Map<String, dynamic> json) => _$UnitPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitPageModelToJson(this);
}

@JsonSerializable()
class UnitApiResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<UnitData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  UnitApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  UnitApiResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<UnitData>? data,
    bool? hasMore,
  }) => UnitApiResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory UnitApiResult.fromJson(Map<String, dynamic> json) => _$UnitApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$UnitApiResultToJson(this);
}
