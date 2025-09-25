// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_invoice_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierInvoiceEditModel _$SupplierInvoiceEditModelFromJson(
  Map<String, dynamic> json,
) => SupplierInvoiceEditModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  apiResult: json['apiResult'] == null
      ? null
      : SupplierInvoiceEditResult.fromJson(
          json['apiResult'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SupplierInvoiceEditModelToJson(
  SupplierInvoiceEditModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.apiResult,
};

SupplierInvoiceEditResult _$SupplierInvoiceEditResultFromJson(
  Map<String, dynamic> json,
) => SupplierInvoiceEditResult(
  invoice: json['invoice'] == null
      ? null
      : Invoice.fromJson(json['invoice'] as Map<String, dynamic>),
  invoiceDetail: (json['invoiceDetail'] as List<dynamic>?)
      ?.map((e) => InvoiceDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SupplierInvoiceEditResultToJson(
  SupplierInvoiceEditResult instance,
) => <String, dynamic>{
  'invoice': instance.invoice,
  'invoiceDetail': instance.invoiceDetail,
};
