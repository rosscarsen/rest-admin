// To parse this JSON data, do
//
//     final supplierInvoiceDataModel = supplierInvoiceDataModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'supplier_invoice_data_model.g.dart';

SupplierInvoiceDataModel supplierInvoiceDataModelFromJson(String str) =>
    SupplierInvoiceDataModel.fromJson(json.decode(str));

String supplierInvoiceDataModelToJson(SupplierInvoiceDataModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierInvoiceDataModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierInvoiceDataResult? apiResult;

  SupplierInvoiceDataModel({this.status, this.msg, this.apiResult});

  SupplierInvoiceDataModel copyWith({int? status, String? msg, SupplierInvoiceDataResult? apiResult}) =>
      SupplierInvoiceDataModel(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        apiResult: apiResult ?? this.apiResult,
      );

  factory SupplierInvoiceDataModel.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceDataModelToJson(this);
}

@JsonSerializable()
class SupplierInvoiceDataResult {
  @JsonKey(name: "invoice")
  Invoice? invoice;
  @JsonKey(name: "invoiceDetail")
  List<InvoiceDetail>? invoiceDetail;
  @JsonKey(name: "supplier")
  Supplier? supplier;

  SupplierInvoiceDataResult({this.invoice, this.invoiceDetail, this.supplier});

  SupplierInvoiceDataResult copyWith({Invoice? invoice, List<InvoiceDetail>? invoiceDetail, Supplier? supplier}) =>
      SupplierInvoiceDataResult(
        invoice: invoice ?? this.invoice,
        invoiceDetail: invoiceDetail ?? this.invoiceDetail,
        supplier: supplier ?? this.supplier,
      );

  factory SupplierInvoiceDataResult.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceDataResultFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceDataResultToJson(this);
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

@JsonSerializable()
class Supplier {
  @JsonKey(name: "mAddress")
  String? mAddress;
  @JsonKey(name: "mAns_Back")
  String? mAnsBack;
  @JsonKey(name: "mCode")
  String? mCode;
  @JsonKey(name: "mContact")
  String? mContact;
  @JsonKey(name: "mFax_No")
  String? mFaxNo;
  @JsonKey(name: "mFullName")
  String? mFullName;
  @JsonKey(name: "mPhone_No")
  String? mPhoneNo;
  @JsonKey(name: "mSimpleName")
  String? mSimpleName;
  @JsonKey(name: "mST_Currency")
  String? mStCurrency;
  @JsonKey(name: "mST_Payment_Days")
  int? mStPaymentDays;
  @JsonKey(name: "mST_Discount")
  String? mStDiscount;
  @JsonKey(name: "mST_Payment_Method")
  int? mStPaymentMethod;
  @JsonKey(name: "mST_Payment_Term")
  String? mStPaymentTerm;
  @JsonKey(name: "mTelex")
  String? mTelex;
  @JsonKey(name: "T_Supplier_ID")
  int? tSupplierId;
  @JsonKey(name: "mEmail")
  String? mEmail;
  @JsonKey(name: "mRemarks")
  String? mRemarks;
  @JsonKey(name: "mNon_Active")
  int? mNonActive;

  Supplier({
    this.mAddress,
    this.mAnsBack,
    this.mCode,
    this.mContact,
    this.mFaxNo,
    this.mFullName,
    this.mPhoneNo,
    this.mSimpleName,
    this.mStCurrency,
    this.mStPaymentDays,
    this.mStDiscount,
    this.mStPaymentMethod,
    this.mStPaymentTerm,
    this.mTelex,
    this.tSupplierId,
    this.mEmail,
    this.mRemarks,
    this.mNonActive,
  });

  Supplier copyWith({
    String? mAddress,
    String? mAnsBack,
    String? mCode,
    String? mContact,
    String? mFaxNo,
    String? mFullName,
    String? mPhoneNo,
    String? mSimpleName,
    String? mStCurrency,
    int? mStPaymentDays,
    String? mStDiscount,
    int? mStPaymentMethod,
    String? mStPaymentTerm,
    String? mTelex,
    int? tSupplierId,
    String? mEmail,
    String? mRemarks,
    int? mNonActive,
  }) => Supplier(
    mAddress: mAddress ?? this.mAddress,
    mAnsBack: mAnsBack ?? this.mAnsBack,
    mCode: mCode ?? this.mCode,
    mContact: mContact ?? this.mContact,
    mFaxNo: mFaxNo ?? this.mFaxNo,
    mFullName: mFullName ?? this.mFullName,
    mPhoneNo: mPhoneNo ?? this.mPhoneNo,
    mSimpleName: mSimpleName ?? this.mSimpleName,
    mStCurrency: mStCurrency ?? this.mStCurrency,
    mStPaymentDays: mStPaymentDays ?? this.mStPaymentDays,
    mStDiscount: mStDiscount ?? this.mStDiscount,
    mStPaymentMethod: mStPaymentMethod ?? this.mStPaymentMethod,
    mStPaymentTerm: mStPaymentTerm ?? this.mStPaymentTerm,
    mTelex: mTelex ?? this.mTelex,
    tSupplierId: tSupplierId ?? this.tSupplierId,
    mEmail: mEmail ?? this.mEmail,
    mRemarks: mRemarks ?? this.mRemarks,
    mNonActive: mNonActive ?? this.mNonActive,
  );

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}
