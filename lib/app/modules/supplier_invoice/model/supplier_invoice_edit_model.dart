// To parse this JSON data, do
//
//     final supplierInvoiceEditModel = supplierInvoiceEditModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../../model/currency/currency_data.dart';
import '../../../model/stock/stock_data.dart';
import '../../../model/supplierInvoice/supplier_invoice_api_model.dart';

part 'supplier_invoice_edit_model.g.dart';

SupplierInvoiceEditModel supplierInvoiceEditModelFromJson(String str) =>
    SupplierInvoiceEditModel.fromJson(json.decode(str));

String supplierInvoiceEditModelToJson(SupplierInvoiceEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierInvoiceEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SupplierInvoiceEditResult? apiResult;

  SupplierInvoiceEditModel({this.status, this.msg, this.apiResult});

  SupplierInvoiceEditModel copyWith({int? status, String? msg, SupplierInvoiceEditResult? apiResult}) =>
      SupplierInvoiceEditModel(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        apiResult: apiResult ?? this.apiResult,
      );

  factory SupplierInvoiceEditModel.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SupplierInvoiceEditResult {
  @JsonKey(name: "invoice")
  Invoice? invoice;
  @JsonKey(name: "invoiceDetail")
  List<InvoiceDetail>? invoiceDetail;
  @JsonKey(name: "currency")
  List<CurrencyData>? currency;
  @JsonKey(name: "stock")
  List<StockData>? stock;

  SupplierInvoiceEditResult({this.invoice, this.invoiceDetail, this.currency, this.stock});

  SupplierInvoiceEditResult copyWith({
    Invoice? invoice,
    List<InvoiceDetail>? invoiceDetail,
    List<CurrencyData>? currency,
    List<StockData>? stock,
  }) => SupplierInvoiceEditResult(
    invoice: invoice ?? this.invoice,
    invoiceDetail: invoiceDetail ?? this.invoiceDetail,
    currency: currency ?? this.currency,
    stock: stock ?? this.stock,
  );

  factory SupplierInvoiceEditResult.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceEditResultFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceEditResultToJson(this);
}
