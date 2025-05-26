// To parse this JSON data, do
//
//     final supplierModel = supplierModelFromJson(jsonString);

import 'dart:convert';

SupplierModel supplierModelFromJson(String str) => SupplierModel.fromJson(json.decode(str));

String supplierModelToJson(SupplierModel data) => json.encode(data.toJson());

class SupplierModel {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<SupplierData>? supplierData;
  bool? hasMore;

  SupplierModel({this.total, this.perPage, this.currentPage, this.lastPage, this.supplierData, this.hasMore});

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    supplierData:
        json["data"] == null ? [] : List<SupplierData>.from(json["data"]!.map((x) => SupplierData.fromJson(x))),
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "data": supplierData == null ? [] : List<dynamic>.from(supplierData!.map((x) => x.toJson())),
    "has_more": hasMore,
  };
}

class SupplierData {
  String? mAddress;
  String? mAnsBack;
  String? mCode;
  String? mContact;
  String? mFaxNo;
  String? mFullName;
  String? mPhoneNo;
  String? mSimpleName;
  String? mStCurrency;
  int? mStPaymentDays;
  String? mStDiscount;
  int? mStPaymentMethod;
  String? mStPaymentTerm;
  String? mTelex;
  int? tSupplierId;
  String? mEmail;
  String? mRemarks;
  int? mNonActive;

  SupplierData({
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

  factory SupplierData.fromJson(Map<String, dynamic> json) => SupplierData(
    mAddress: json["mAddress"],
    mAnsBack: json["mAns_Back"],
    mCode: json["mCode"],
    mContact: json["mContact"],
    mFaxNo: json["mFax_No"],
    mFullName: json["mFullName"],
    mPhoneNo: json["mPhone_No"],
    mSimpleName: json["mSimpleName"],
    mStCurrency: json["mST_Currency"],
    mStPaymentDays: json["mST_Payment_Days"],
    mStDiscount: json["mST_Discount"],
    mStPaymentMethod: json["mST_Payment_Method"],
    mStPaymentTerm: json["mST_Payment_Term"],
    mTelex: json["mTelex"],
    tSupplierId: json["T_Supplier_ID"],
    mEmail: json["mEmail"],
    mRemarks: json["mRemarks"],
    mNonActive: json["mNon_Active"],
  );

  Map<String, dynamic> toJson() => {
    "mAddress": mAddress,
    "mAns_Back": mAnsBack,
    "mCode": mCode,
    "mContact": mContact,
    "mFax_No": mFaxNo,
    "mFullName": mFullName,
    "mPhone_No": mPhoneNo,
    "mSimpleName": mSimpleName,
    "mST_Currency": mStCurrency,
    "mST_Payment_Days": mStPaymentDays,
    "mST_Discount": mStDiscount,
    "mST_Payment_Method": mStPaymentMethod,
    "mST_Payment_Term": mStPaymentTerm,
    "mTelex": mTelex,
    "T_Supplier_ID": tSupplierId,
    "mEmail": mEmail,
    "mRemarks": mRemarks,
    "mNon_Active": mNonActive,
  };
}
