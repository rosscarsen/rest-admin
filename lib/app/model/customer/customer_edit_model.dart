// To parse this JSON data, do
//
//     final customerEditModel = customerEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../currency/currency_data.dart';
import '../pay_method/pay_method_data.dart';
import 'customer_data.dart';

part 'customer_edit_model.g.dart';

CustomerEditModel customerEditModelFromJson(String str) => CustomerEditModel.fromJson(json.decode(str));

String customerEditModelToJson(CustomerEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class CustomerEditModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final ApiResult? apiResult;

  CustomerEditModel({this.status, this.msg, this.apiResult});

  CustomerEditModel copyWith({int? status, String? msg, ApiResult? apiResult}) =>
      CustomerEditModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory CustomerEditModel.fromJson(Map<String, dynamic> json) => _$CustomerEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerEditModelToJson(this);
}

@JsonSerializable()
class ApiResult {
  @JsonKey(name: "customerInfo")
  final CustomerData? customerInfo;
  @JsonKey(name: "customerType")
  final List<String>? customerType;
  @JsonKey(name: "customerContact")
  final dynamic customerContact;
  @JsonKey(name: "invoiceAmount")
  final String? invoiceAmount;
  @JsonKey(name: "customerPoint")
  final String? customerPoint;
  @JsonKey(name: "currency")
  final List<CurrencyData>? currency;

  ApiResult({
    this.customerInfo,
    this.customerType,
    this.customerContact,
    this.invoiceAmount,
    this.customerPoint,
    this.currency,
  });

  ApiResult copyWith({
    CustomerData? customerInfo,
    List<String>? customerType,
    dynamic customerContact,
    String? invoiceAmount,
    String? customerPoint,
    List<CurrencyData>? currency,
    List<PayMethodData>? payment,
  }) => ApiResult(
    customerInfo: customerInfo ?? this.customerInfo,
    customerType: customerType ?? this.customerType,
    customerContact: customerContact ?? this.customerContact,
    invoiceAmount: invoiceAmount ?? this.invoiceAmount,
    customerPoint: customerPoint ?? this.customerPoint,
    currency: currency ?? this.currency,
  );

  factory ApiResult.fromJson(Map<String, dynamic> json) => _$ApiResultFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResultToJson(this);
}
