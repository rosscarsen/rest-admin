// To parse this JSON data, do
//
//     final supplierInvoiceModel = supplierInvoiceModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../model/supplierInvoice/supplier_invoice_api_model.dart';
import '../../../utils/functions.dart';

part 'supplier_invoice_model.g.dart';

SupplierInvoiceModel supplierInvoiceModelFromJson(String str) => SupplierInvoiceModel.fromJson(json.decode(str));

String supplierInvoiceModelToJson(SupplierInvoiceModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierInvoiceModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierInvoiceRet? supplierInvoiceRet;

  SupplierInvoiceModel({this.status, this.msg, this.supplierInvoiceRet});

  SupplierInvoiceModel copyWith({int? status, String? msg, SupplierInvoiceRet? supplierInvoiceRet}) =>
      SupplierInvoiceModel(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        supplierInvoiceRet: supplierInvoiceRet ?? this.supplierInvoiceRet,
      );

  factory SupplierInvoiceModel.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceModelToJson(this);
}

@JsonSerializable()
class SupplierInvoiceRet {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<Invoice>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  SupplierInvoiceRet({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  SupplierInvoiceRet copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<Invoice>? data,
    bool? hasMore,
  }) => SupplierInvoiceRet(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory SupplierInvoiceRet.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceRetFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceRetToJson(this);
}
