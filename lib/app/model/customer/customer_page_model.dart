// To parse this JSON data, do
//
//      customerPageModel = customerPageModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'customer_data.dart';

part 'customer_page_model.g.dart';

CustomerPageModel customerPageModelFromJson(String str) => CustomerPageModel.fromJson(json.decode(str));

String customerPageModelToJson(CustomerPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class CustomerPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  ApiResult? apiResult;

  CustomerPageModel({this.status, this.msg, this.apiResult});

  CustomerPageModel copyWith({int? status, String? msg, ApiResult? apiResult}) =>
      CustomerPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory CustomerPageModel.fromJson(Map<String, dynamic> json) => _$CustomerPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerPageModelToJson(this);
}

@JsonSerializable()
class ApiResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<CustomerData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  ApiResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<CustomerData>? data,
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
