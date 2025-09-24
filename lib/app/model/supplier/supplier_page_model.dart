// To parse this JSON data, do
//
//     final supplierModel = supplierModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'supplier_data.dart';

part 'supplier_page_model.g.dart';

SupplierPageModel supplierPageModelFromJson(String str) => SupplierPageModel.fromJson(json.decode(str));

String supplierPageModelToJson(SupplierPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierApiResult? apiResult;

  SupplierPageModel({this.status, this.msg, this.apiResult});

  SupplierPageModel copyWith({int? status, String? msg, SupplierApiResult? apiResult}) =>
      SupplierPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory SupplierPageModel.fromJson(Map<String, dynamic> json) => _$SupplierPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierPageModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SupplierApiResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<SupplierData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  SupplierApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  SupplierApiResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<SupplierData>? data,
    bool? hasMore,
  }) => SupplierApiResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory SupplierApiResult.fromJson(Map<String, dynamic> json) => _$SupplierApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierApiResultToJson(this);
}
