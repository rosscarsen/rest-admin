// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierInvoiceModel _$SupplierInvoiceModelFromJson(
  Map<String, dynamic> json,
) => SupplierInvoiceModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  supplierInvoiceRet: json['apiResult'] == null
      ? null
      : SupplierInvoiceRet.fromJson(json['apiResult'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SupplierInvoiceModelToJson(
  SupplierInvoiceModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.supplierInvoiceRet,
};

SupplierInvoiceRet _$SupplierInvoiceRetFromJson(Map<String, dynamic> json) =>
    SupplierInvoiceRet(
      total: (json['total'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$SupplierInvoiceRetToJson(SupplierInvoiceRet instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.data,
      'has_more': instance.hasMore,
    };
