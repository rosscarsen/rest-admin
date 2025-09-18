// To parse this JSON data, do
//
//     final supplierInvoiceModel = supplierInvoiceModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../utils/functions.dart';

part 'supplier_invoice_model.g.dart';

SupplierInvoiceModel supplierInvoiceModelFromJson(String str) => SupplierInvoiceModel.fromJson(json.decode(str));

String supplierInvoiceModelToJson(SupplierInvoiceModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class SupplierInvoiceModel {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<InvoiceDataModel>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  SupplierInvoiceModel({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  SupplierInvoiceModel copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<InvoiceDataModel>? data,
    bool? hasMore,
  }) => SupplierInvoiceModel(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory SupplierInvoiceModel.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InvoiceDataModel {
  @JsonKey(name: "mSupplier_Invoice_In_No", fromJson: Functions.asString)
  String? mSupplierInvoiceInNo;
  @JsonKey(name: "mSupplier_Invoice_In_Date", fromJson: _fromJson)
  String? mSupplierInvoiceInDate;
  static String? _fromJson(dynamic v) {
    final raw = v?.toString() ?? "";
    if (raw.isEmpty) return null; // 防止空字符串崩溃
    return raw.substring(0, 10); // 取前10位 yyyy-MM-dd
  }

  @JsonKey(name: "mMoneyCurrency", fromJson: Functions.asString)
  String? mMoneyCurrency;
  @JsonKey(name: "mDiscount", fromJson: Functions.asString)
  String? mDiscount;
  @JsonKey(name: "mAmount", fromJson: Functions.asString)
  String? mAmount;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mSupplier_Code", fromJson: Functions.asString)
  String? mSupplierCode;
  @JsonKey(name: "mSupplier_Name", fromJson: Functions.asString)
  String? mSupplierName;
  @JsonKey(name: "T_Supplier_Invoice_In_ID", fromJson: Functions.asString)
  String? tSupplierInvoiceInId;
  @JsonKey(name: "mCreated_Date", fromJson: Functions.asString)
  String? mCreatedDate;
  @JsonKey(name: "mLast_Modified_Date", fromJson: Functions.asString)
  String? mLastModifiedDate;
  @JsonKey(name: "mCreated_By", fromJson: Functions.asString)
  String? mCreatedBy;
  @JsonKey(name: "mLast_Modified_By", fromJson: Functions.asString)
  String? mLastModifiedBy;
  @JsonKey(name: "mEx_Ratio", fromJson: Functions.asString)
  String? mExRatio;
  @JsonKey(name: "mRevised", fromJson: Functions.asString)
  String? mRevised;
  @JsonKey(name: "mFlag", fromJson: Functions.asString)
  String? mFlag;
  @JsonKey(name: "mRef_Supplier_Invoice_No", fromJson: Functions.asString)
  String? mRefSupplierInvoiceNo;

  InvoiceDataModel({
    this.mSupplierInvoiceInNo,
    this.mSupplierInvoiceInDate,
    this.mMoneyCurrency,
    this.mDiscount,
    this.mAmount,
    this.mRemarks,
    this.mSupplierCode,
    this.mSupplierName,
    this.tSupplierInvoiceInId,
    this.mCreatedDate,
    this.mLastModifiedDate,
    this.mCreatedBy,
    this.mLastModifiedBy,
    this.mExRatio,
    this.mRevised,
    this.mFlag,
    this.mRefSupplierInvoiceNo,
  });

  InvoiceDataModel copyWith({
    String? mSupplierInvoiceInNo,
    String? mSupplierInvoiceInDate,
    String? mMoneyCurrency,
    String? mDiscount,
    String? mAmount,
    String? mRemarks,
    String? mSupplierCode,
    String? mSupplierName,
    String? tSupplierInvoiceInId,
    String? mCreatedDate,
    String? mLastModifiedDate,
    String? mCreatedBy,
    String? mLastModifiedBy,
    String? mExRatio,
    String? mRevised,
    String? mFlag,
    String? mRefSupplierInvoiceNo,
  }) => InvoiceDataModel(
    mSupplierInvoiceInNo: mSupplierInvoiceInNo ?? this.mSupplierInvoiceInNo,
    mSupplierInvoiceInDate: mSupplierInvoiceInDate ?? this.mSupplierInvoiceInDate,
    mMoneyCurrency: mMoneyCurrency ?? this.mMoneyCurrency,
    mDiscount: mDiscount ?? this.mDiscount,
    mAmount: mAmount ?? this.mAmount,
    mRemarks: mRemarks ?? this.mRemarks,
    mSupplierCode: mSupplierCode ?? this.mSupplierCode,
    mSupplierName: mSupplierName ?? this.mSupplierName,
    tSupplierInvoiceInId: tSupplierInvoiceInId ?? this.tSupplierInvoiceInId,
    mCreatedDate: mCreatedDate ?? this.mCreatedDate,
    mLastModifiedDate: mLastModifiedDate ?? this.mLastModifiedDate,
    mCreatedBy: mCreatedBy ?? this.mCreatedBy,
    mLastModifiedBy: mLastModifiedBy ?? this.mLastModifiedBy,
    mExRatio: mExRatio ?? this.mExRatio,
    mRevised: mRevised ?? this.mRevised,
    mFlag: mFlag ?? this.mFlag,
    mRefSupplierInvoiceNo: mRefSupplierInvoiceNo ?? this.mRefSupplierInvoiceNo,
  );

  factory InvoiceDataModel.fromJson(Map<String, dynamic> json) => _$InvoiceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDataModelToJson(this);

  void updateFromSource(InvoiceDataModel model) {
    mSupplierInvoiceInNo = model.mSupplierInvoiceInNo;
    mSupplierInvoiceInDate = model.mSupplierInvoiceInDate;
    mMoneyCurrency = model.mMoneyCurrency;
    mDiscount = model.mDiscount;
    mAmount = model.mAmount;
    mRemarks = model.mRemarks;
    mSupplierCode = model.mSupplierCode;
    mSupplierName = model.mSupplierName;
    tSupplierInvoiceInId = model.tSupplierInvoiceInId;
    mCreatedDate = model.mCreatedDate;
    mLastModifiedDate = model.mLastModifiedDate;
    mCreatedBy = model.mCreatedBy;
    mLastModifiedBy = model.mLastModifiedBy;
    mExRatio = model.mExRatio;
    mRevised = model.mRevised;
    mFlag = model.mFlag;
    mRefSupplierInvoiceNo = model.mRefSupplierInvoiceNo;
  }
}
