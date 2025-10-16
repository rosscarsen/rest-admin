// To parse this JSON data, do
//
//     final supplierEditModel = supplierEditModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../../../../model/currency/currency_data.dart';
import '../../../../../model/supplier/supplier_data.dart';
import '../../../../../utils/functions.dart';

part 'supplier_edit_model.g.dart';

SupplierEditModel supplierEditModelFromJson(String str) => SupplierEditModel.fromJson(json.decode(str));

String supplierEditModelToJson(SupplierEditModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class SupplierEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierEditData? apiResult;

  SupplierEditModel({this.status, this.msg, this.apiResult});

  SupplierEditModel copyWith({int? status, String? msg, SupplierEditData? apiResult}) =>
      SupplierEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory SupplierEditModel.fromJson(Map<String, dynamic> json) => _$SupplierEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SupplierEditData extends SupplierData {
  @JsonKey(name: "currency")
  List<CurrencyData>? currency;

  SupplierEditData({
    super.mAddress,
    super.mAnsBack,
    super.mCode,
    super.mContact,
    super.mFaxNo,
    super.mFullName,
    super.mPhoneNo,
    super.mSimpleName,
    super.mStCurrency,
    super.mStPaymentDays,
    super.mStDiscount,
    super.mStPaymentMethod,
    super.mStPaymentTerm,
    super.mTelex,
    super.tSupplierId,
    super.mEmail,
    super.mRemarks,
    super.mNonActive,
    this.currency,
  });

  @override
  SupplierEditData copyWith({
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
  }) => SupplierEditData(
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

  factory SupplierEditData.fromJson(Map<String, dynamic> json) => _$SupplierEditDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SupplierEditDataToJson(this);
}
