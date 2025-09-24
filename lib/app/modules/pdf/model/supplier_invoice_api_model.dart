// To parse this JSON data, do
//
//     final supplierInvoiceApiModel = supplierInvoiceApiModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../model/company/company_model.dart';
import '../../../model/supplier/supplier_data.dart';

part 'supplier_invoice_api_model.g.dart';

SupplierInvoiceApiModel supplierInvoiceApiModelFromJson(String str) =>
    SupplierInvoiceApiModel.fromJson(json.decode(str));

String supplierInvoiceApiModelToJson(SupplierInvoiceApiModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierInvoiceApiModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierInvoiceApiResult? apiResult;

  SupplierInvoiceApiModel({this.status, this.msg, this.apiResult});

  SupplierInvoiceApiModel copyWith({int? status, String? msg, SupplierInvoiceApiResult? apiResult}) =>
      SupplierInvoiceApiModel(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        apiResult: apiResult ?? this.apiResult,
      );

  factory SupplierInvoiceApiModel.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceApiModelToJson(this);
}

@JsonSerializable()
class SupplierInvoiceApiResult {
  @JsonKey(name: "invoice")
  Invoice? invoice;
  @JsonKey(name: "invoiceDetail")
  List<InvoiceDetail>? invoiceDetail;
  @JsonKey(name: "supplier")
  SupplierData? supplier;
  @JsonKey(name: "company")
  Company? company;

  SupplierInvoiceApiResult({this.invoice, this.invoiceDetail, this.supplier, this.company});

  SupplierInvoiceApiResult copyWith({
    Invoice? invoice,
    List<InvoiceDetail>? invoiceDetail,
    SupplierData? supplier,
    Company? company,
  }) => SupplierInvoiceApiResult(
    invoice: invoice ?? this.invoice,
    invoiceDetail: invoiceDetail ?? this.invoiceDetail,
    supplier: supplier ?? this.supplier,
    company: company ?? this.company,
  );

  factory SupplierInvoiceApiResult.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceApiResultToJson(this);
}

@JsonSerializable()
class Invoice {
  @JsonKey(name: "mSupplier_Invoice_In_No")
  String? mSupplierInvoiceInNo;
  @JsonKey(name: "mSupplier_Invoice_In_Date")
  DateTime? mSupplierInvoiceInDate;
  @JsonKey(name: "mMoneyCurrency")
  String? mMoneyCurrency;
  @JsonKey(name: "mDiscount")
  String? mDiscount;
  @JsonKey(name: "mAmount")
  String? mAmount;
  @JsonKey(name: "mRemarks")
  String? mRemarks;
  @JsonKey(name: "mSupplier_Code")
  String? mSupplierCode;
  @JsonKey(name: "mSupplier_Name")
  String? mSupplierName;
  @JsonKey(name: "T_Supplier_Invoice_In_ID")
  int? tSupplierInvoiceInId;
  @JsonKey(name: "mCreated_Date")
  DateTime? mCreatedDate;
  @JsonKey(name: "mLast_Modified_Date")
  DateTime? mLastModifiedDate;
  @JsonKey(name: "mCreated_By")
  String? mCreatedBy;
  @JsonKey(name: "mLast_Modified_By")
  String? mLastModifiedBy;
  @JsonKey(name: "mEx_Ratio")
  String? mExRatio;
  @JsonKey(name: "mRevised")
  String? mRevised;
  @JsonKey(name: "mFlag")
  int? mFlag;
  @JsonKey(name: "mRef_Supplier_Invoice_No")
  dynamic mRefSupplierInvoiceNo;

  Invoice({
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

  Invoice copyWith({
    String? mSupplierInvoiceInNo,
    DateTime? mSupplierInvoiceInDate,
    String? mMoneyCurrency,
    String? mDiscount,
    String? mAmount,
    String? mRemarks,
    String? mSupplierCode,
    String? mSupplierName,
    int? tSupplierInvoiceInId,
    DateTime? mCreatedDate,
    DateTime? mLastModifiedDate,
    String? mCreatedBy,
    String? mLastModifiedBy,
    String? mExRatio,
    String? mRevised,
    int? mFlag,
    dynamic mRefSupplierInvoiceNo,
  }) => Invoice(
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

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}

@JsonSerializable()
class InvoiceDetail {
  @JsonKey(name: "mItem")
  int? mItem;
  @JsonKey(name: "mProduct_Code")
  String? mProductCode;
  @JsonKey(name: "mProduct_Name")
  String? mProductName;
  @JsonKey(name: "mPrice")
  String? mPrice;
  @JsonKey(name: "mQty")
  String? mQty;
  @JsonKey(name: "mAmount")
  String? mAmount;
  @JsonKey(name: "mDiscount")
  String? mDiscount;
  @JsonKey(name: "mRemarks")
  String? mRemarks;
  @JsonKey(name: "T_Supplier_Invoice_In_ID")
  int? tSupplierInvoiceInId;
  @JsonKey(name: "mPo_Detail_ID")
  dynamic mPoDetailId;
  @JsonKey(name: "mStock_Code")
  String? mStockCode;
  @JsonKey(name: "mUnit")
  String? mUnit;
  @JsonKey(name: "mSupplier_Invoice_In_Detail_ID")
  int? mSupplierInvoiceInDetailId;
  @JsonKey(name: "mPO_No")
  dynamic mPoNo;
  @JsonKey(name: "mRevised")
  dynamic mRevised;
  @JsonKey(name: "mProduct_Content")
  String? mProductContent;

  InvoiceDetail({
    this.mItem,
    this.mProductCode,
    this.mProductName,
    this.mPrice,
    this.mQty,
    this.mAmount,
    this.mDiscount,
    this.mRemarks,
    this.tSupplierInvoiceInId,
    this.mPoDetailId,
    this.mStockCode,
    this.mUnit,
    this.mSupplierInvoiceInDetailId,
    this.mPoNo,
    this.mRevised,
    this.mProductContent,
  });

  InvoiceDetail copyWith({
    int? mItem,
    String? mProductCode,
    String? mProductName,
    String? mPrice,
    String? mQty,
    String? mAmount,
    String? mDiscount,
    String? mRemarks,
    int? tSupplierInvoiceInId,
    dynamic mPoDetailId,
    String? mStockCode,
    String? mUnit,
    int? mSupplierInvoiceInDetailId,
    dynamic mPoNo,
    dynamic mRevised,
    String? mProductContent,
  }) => InvoiceDetail(
    mItem: mItem ?? this.mItem,
    mProductCode: mProductCode ?? this.mProductCode,
    mProductName: mProductName ?? this.mProductName,
    mPrice: mPrice ?? this.mPrice,
    mQty: mQty ?? this.mQty,
    mAmount: mAmount ?? this.mAmount,
    mDiscount: mDiscount ?? this.mDiscount,
    mRemarks: mRemarks ?? this.mRemarks,
    tSupplierInvoiceInId: tSupplierInvoiceInId ?? this.tSupplierInvoiceInId,
    mPoDetailId: mPoDetailId ?? this.mPoDetailId,
    mStockCode: mStockCode ?? this.mStockCode,
    mUnit: mUnit ?? this.mUnit,
    mSupplierInvoiceInDetailId: mSupplierInvoiceInDetailId ?? this.mSupplierInvoiceInDetailId,
    mPoNo: mPoNo ?? this.mPoNo,
    mRevised: mRevised ?? this.mRevised,
    mProductContent: mProductContent ?? this.mProductContent,
  );

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => _$InvoiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDetailToJson(this);
}
