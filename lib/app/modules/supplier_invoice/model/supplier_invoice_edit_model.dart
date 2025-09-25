// To parse this JSON data, do
//
//     final supplierInvoiceEditModel = supplierInvoiceEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

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

@JsonSerializable()
class SupplierInvoiceEditResult {
  @JsonKey(name: "invoice")
  Invoice? invoice;
  @JsonKey(name: "invoiceDetail")
  List<InvoiceDetail>? invoiceDetail;

  SupplierInvoiceEditResult({this.invoice, this.invoiceDetail});

  SupplierInvoiceEditResult copyWith({Invoice? invoice, List<InvoiceDetail>? invoiceDetail}) =>
      SupplierInvoiceEditResult(invoice: invoice ?? this.invoice, invoiceDetail: invoiceDetail ?? this.invoiceDetail);

  factory SupplierInvoiceEditResult.fromJson(Map<String, dynamic> json) => _$SupplierInvoiceEditResultFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierInvoiceEditResultToJson(this);
}
