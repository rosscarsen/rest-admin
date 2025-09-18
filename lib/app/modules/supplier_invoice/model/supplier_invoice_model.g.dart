// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierInvoiceModel _$SupplierInvoiceModelFromJson(
  Map<String, dynamic> json,
) => SupplierInvoiceModel(
  total: (json['total'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => InvoiceDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMore: json['has_more'] as bool?,
);

Map<String, dynamic> _$SupplierInvoiceModelToJson(
  SupplierInvoiceModel instance,
) => <String, dynamic>{
  'total': instance.total,
  'per_page': instance.perPage,
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'data': instance.data?.map((e) => e.toJson()).toList(),
  'has_more': instance.hasMore,
};

InvoiceDataModel _$InvoiceDataModelFromJson(
  Map<String, dynamic> json,
) => InvoiceDataModel(
  mSupplierInvoiceInNo: Functions.asString(json['mSupplier_Invoice_In_No']),
  mSupplierInvoiceInDate: InvoiceDataModel._fromJson(
    json['mSupplier_Invoice_In_Date'],
  ),
  mMoneyCurrency: Functions.asString(json['mMoneyCurrency']),
  mDiscount: Functions.asString(json['mDiscount']),
  mAmount: Functions.asString(json['mAmount']),
  mRemarks: Functions.asString(json['mRemarks']),
  mSupplierCode: Functions.asString(json['mSupplier_Code']),
  mSupplierName: Functions.asString(json['mSupplier_Name']),
  tSupplierInvoiceInId: Functions.asString(json['T_Supplier_Invoice_In_ID']),
  mCreatedDate: Functions.asString(json['mCreated_Date']),
  mLastModifiedDate: Functions.asString(json['mLast_Modified_Date']),
  mCreatedBy: Functions.asString(json['mCreated_By']),
  mLastModifiedBy: Functions.asString(json['mLast_Modified_By']),
  mExRatio: Functions.asString(json['mEx_Ratio']),
  mRevised: Functions.asString(json['mRevised']),
  mFlag: Functions.asString(json['mFlag']),
  mRefSupplierInvoiceNo: Functions.asString(json['mRef_Supplier_Invoice_No']),
);

Map<String, dynamic> _$InvoiceDataModelToJson(InvoiceDataModel instance) =>
    <String, dynamic>{
      'mSupplier_Invoice_In_No': instance.mSupplierInvoiceInNo,
      'mSupplier_Invoice_In_Date': instance.mSupplierInvoiceInDate,
      'mMoneyCurrency': instance.mMoneyCurrency,
      'mDiscount': instance.mDiscount,
      'mAmount': instance.mAmount,
      'mRemarks': instance.mRemarks,
      'mSupplier_Code': instance.mSupplierCode,
      'mSupplier_Name': instance.mSupplierName,
      'T_Supplier_Invoice_In_ID': instance.tSupplierInvoiceInId,
      'mCreated_Date': instance.mCreatedDate,
      'mLast_Modified_Date': instance.mLastModifiedDate,
      'mCreated_By': instance.mCreatedBy,
      'mLast_Modified_By': instance.mLastModifiedBy,
      'mEx_Ratio': instance.mExRatio,
      'mRevised': instance.mRevised,
      'mFlag': instance.mFlag,
      'mRef_Supplier_Invoice_No': instance.mRefSupplierInvoiceNo,
    };
