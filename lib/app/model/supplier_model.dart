// To parse this JSON data, do
//
//     final supplierModelModel = supplierModelModelFromJson(jsonString);

import 'dart:convert';

SupplierModelModel supplierModelModelFromJson(String str) => SupplierModelModel.fromJson(json.decode(str));

String supplierModelModelToJson(SupplierModelModel data) => json.encode(data.toJson());

class SupplierModelModel {
  int? status;
  String? msg;
  ApiResult? apiResult;

  SupplierModelModel({this.status, this.msg, this.apiResult});

  factory SupplierModelModel.fromJson(Map<String, dynamic> json) => SupplierModelModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ApiResult {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<ApiData>? apiData;
  bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.apiData, this.hasMore});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    apiData: json["data"] == null ? [] : List<ApiData>.from(json["data"]!.map((x) => ApiData.fromJson(x))),
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "data": apiData == null ? [] : List<dynamic>.from(apiData!.map((x) => x.toJson())),
    "has_more": hasMore,
  };
}

class ApiData {
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

  ApiData({
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

  factory ApiData.fromJson(Map<String, dynamic> json) => ApiData(
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
