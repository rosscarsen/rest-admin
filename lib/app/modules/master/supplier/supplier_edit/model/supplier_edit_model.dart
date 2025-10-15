// To parse this JSON data, do
//
//     final supplierEditModel = supplierEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import '../../../../../model/currency/currency_data.dart';
import '../../../../../utils/functions.dart';

part 'supplier_edit_model.g.dart';

SupplierEditModel supplierEditModelFromJson(String str) => SupplierEditModel.fromJson(json.decode(str));

String supplierEditModelToJson(SupplierEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierEditResult? apiResult;

  SupplierEditModel({this.status, this.msg, this.apiResult});

  SupplierEditModel copyWith({int? status, String? msg, SupplierEditResult? apiResult}) =>
      SupplierEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory SupplierEditModel.fromJson(Map<String, dynamic> json) => _$SupplierEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SupplierEditResult {
  @JsonKey(name: "mAddress", fromJson: Functions.asString)
  String? mAddress;
  @JsonKey(name: "mAns_Back", fromJson: Functions.asString)
  String? mAnsBack;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "mContact", fromJson: Functions.asString)
  String? mContact;
  @JsonKey(name: "mFax_No", fromJson: Functions.asString)
  String? mFaxNo;
  @JsonKey(name: "mFullName", fromJson: Functions.asString)
  String? mFullName;
  @JsonKey(name: "mPhone_No", fromJson: Functions.asString)
  String? mPhoneNo;
  @JsonKey(name: "mSimpleName", fromJson: Functions.asString)
  String? mSimpleName;
  @JsonKey(name: "mST_Currency", fromJson: Functions.asString)
  String? mStCurrency;
  @JsonKey(name: "mST_Payment_Days", fromJson: Functions.asString)
  String? mStPaymentDays;
  @JsonKey(name: "mST_Discount", fromJson: Functions.asString)
  String? mStDiscount;
  @JsonKey(name: "mST_Payment_Method", fromJson: Functions.asString)
  String? mStPaymentMethod;
  @JsonKey(name: "mST_Payment_Term", fromJson: Functions.asString)
  String? mStPaymentTerm;
  @JsonKey(name: "mTelex", fromJson: Functions.asString)
  String? mTelex;
  @JsonKey(name: "T_Supplier_ID", fromJson: Functions.asString)
  String? tSupplierId;
  @JsonKey(name: "mEmail", fromJson: Functions.asString)
  String? mEmail;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mNon_Active", fromJson: Functions.asString)
  String? mNonActive;
  @JsonKey(name: "currency")
  List<CurrencyData>? currency;

  SupplierEditResult({
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
    this.currency,
  });

  SupplierEditResult copyWith({
    String? mAddress,
    String? mAnsBack,
    String? mCode,
    String? mContact,
    String? mFaxNo,
    String? mFullName,
    String? mPhoneNo,
    String? mSimpleName,
    String? mStCurrency,
    String? mStPaymentDays,
    String? mStDiscount,
    String? mStPaymentMethod,
    String? mStPaymentTerm,
    String? mTelex,
    String? tSupplierId,
    String? mEmail,
    String? mRemarks,
    String? mNonActive,
    List<CurrencyData>? currency,
  }) => SupplierEditResult(
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
    currency: currency ?? this.currency,
  );

  factory SupplierEditResult.fromJson(Map<String, dynamic> json) => _$SupplierEditResultFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierEditResultToJson(this);
}
