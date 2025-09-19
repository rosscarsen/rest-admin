// To parse this JSON data, do
//
//      customerEditModel = customerEditModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
import '../currency/currency_data.dart';
import '../pay_method/pay_method_data.dart';
import 'customer_contact.dart';
import 'customer_data.dart';
import 'point_list.dart';

part 'customer_edit_model.g.dart';

CustomerEditModel customerEditModelFromJson(String str) => CustomerEditModel.fromJson(json.decode(str));

String customerEditModelToJson(CustomerEditModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class CustomerEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  CustomerEditResult? apiResult;

  CustomerEditModel({this.status, this.msg, this.apiResult});

  CustomerEditModel copyWith({int? status, String? msg, CustomerEditResult? apiResult}) =>
      CustomerEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory CustomerEditModel.fromJson(Map<String, dynamic> json) => _$CustomerEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CustomerEditResult {
  @JsonKey(name: "customerInfo")
  CustomerData? customerInfo;
  @JsonKey(name: "customerType")
  List<String>? customerType;
  @JsonKey(name: "customerContact")
  List<CustomerContact>? customerContact;
  @JsonKey(name: "invoiceAmount", fromJson: Functions.formatAmount)
  String? invoiceAmount;
  @JsonKey(name: "customerPoint", fromJson: Functions.formatAmount)
  String? customerPoint;
  @JsonKey(name: "currency")
  List<CurrencyData>? currency;
  @JsonKey(name: "customerDiscount")
  List<CustomerDiscount>? customerDiscount;

  CustomerEditResult({
    this.customerInfo,
    this.customerType,
    this.customerContact,
    this.invoiceAmount,
    this.customerPoint,
    this.currency,
    this.customerDiscount,
  });

  CustomerEditResult copyWith({
    CustomerData? customerInfo,
    List<String>? customerType,
    dynamic customerContact,
    String? invoiceAmount,
    String? customerPoint,
    List<CurrencyData>? currency,
    List<PayMethodData>? payment,
    PointList? pointList,
    List<CustomerDiscount>? customerDiscount,
  }) => CustomerEditResult(
    customerInfo: customerInfo ?? this.customerInfo,
    customerType: customerType ?? this.customerType,
    customerContact: customerContact ?? this.customerContact,
    invoiceAmount: invoiceAmount ?? this.invoiceAmount,
    customerPoint: customerPoint ?? this.customerPoint,
    currency: currency ?? this.currency,
    customerDiscount: customerDiscount ?? this.customerDiscount,
  );

  factory CustomerEditResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CustomerDiscount {
  @JsonKey(name: "t_customer_id", fromJson: Functions.asString)
  String? tCustomerId;
  @JsonKey(name: "mItem", fromJson: Functions.asString)
  String? mItem;
  @JsonKey(name: "mCategory", fromJson: Functions.asString)
  String? mCategory;
  @JsonKey(name: "mDiscount", fromJson: Functions.asString)
  String? mDiscount;
  @JsonKey(name: "mExpiry_Date", fromJson: Functions.asString)
  String? mExpiryDate;
  @JsonKey(name: "mNon_Active", fromJson: Functions.asString)
  String? mNonActive;

  CustomerDiscount({this.tCustomerId, this.mItem, this.mCategory, this.mDiscount, this.mExpiryDate, this.mNonActive});

  CustomerDiscount copyWith({
    String? tCustomerId,
    String? mItem,
    String? mCategory,
    String? mDiscount,
    String? mExpiryDate,
    String? mNonActive,
  }) => CustomerDiscount(
    tCustomerId: tCustomerId ?? this.tCustomerId,
    mItem: mItem ?? this.mItem,
    mCategory: mCategory ?? this.mCategory,
    mDiscount: mDiscount ?? this.mDiscount,
    mExpiryDate: mExpiryDate ?? this.mExpiryDate,
    mNonActive: mNonActive ?? this.mNonActive,
  );

  factory CustomerDiscount.fromJson(Map<String, dynamic> json) => _$CustomerDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDiscountToJson(this);
}
