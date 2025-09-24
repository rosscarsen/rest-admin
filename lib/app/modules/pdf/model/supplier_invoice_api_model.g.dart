// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_invoice_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierInvoiceApiModel _$SupplierInvoiceApiModelFromJson(
  Map<String, dynamic> json,
) => SupplierInvoiceApiModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  apiResult: json['apiResult'] == null
      ? null
      : SupplierInvoiceApiResult.fromJson(
          json['apiResult'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SupplierInvoiceApiModelToJson(
  SupplierInvoiceApiModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.apiResult,
};

SupplierInvoiceApiResult _$SupplierInvoiceApiResultFromJson(
  Map<String, dynamic> json,
) => SupplierInvoiceApiResult(
  invoice: json['invoice'] == null
      ? null
      : Invoice.fromJson(json['invoice'] as Map<String, dynamic>),
  invoiceDetail: (json['invoiceDetail'] as List<dynamic>?)
      ?.map((e) => InvoiceDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
  supplier: json['supplier'] == null
      ? null
      : SupplierData.fromJson(json['supplier'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : Company.fromJson(json['company'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SupplierInvoiceApiResultToJson(
  SupplierInvoiceApiResult instance,
) => <String, dynamic>{
  'invoice': instance.invoice,
  'invoiceDetail': instance.invoiceDetail,
  'supplier': instance.supplier,
  'company': instance.company,
};

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
  mSupplierInvoiceInNo: json['mSupplier_Invoice_In_No'] as String?,
  mSupplierInvoiceInDate: json['mSupplier_Invoice_In_Date'] == null
      ? null
      : DateTime.parse(json['mSupplier_Invoice_In_Date'] as String),
  mMoneyCurrency: json['mMoneyCurrency'] as String?,
  mDiscount: json['mDiscount'] as String?,
  mAmount: json['mAmount'] as String?,
  mRemarks: json['mRemarks'] as String?,
  mSupplierCode: json['mSupplier_Code'] as String?,
  mSupplierName: json['mSupplier_Name'] as String?,
  tSupplierInvoiceInId: (json['T_Supplier_Invoice_In_ID'] as num?)?.toInt(),
  mCreatedDate: json['mCreated_Date'] == null
      ? null
      : DateTime.parse(json['mCreated_Date'] as String),
  mLastModifiedDate: json['mLast_Modified_Date'] == null
      ? null
      : DateTime.parse(json['mLast_Modified_Date'] as String),
  mCreatedBy: json['mCreated_By'] as String?,
  mLastModifiedBy: json['mLast_Modified_By'] as String?,
  mExRatio: json['mEx_Ratio'] as String?,
  mRevised: json['mRevised'] as String?,
  mFlag: (json['mFlag'] as num?)?.toInt(),
  mRefSupplierInvoiceNo: json['mRef_Supplier_Invoice_No'],
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  'mSupplier_Invoice_In_No': instance.mSupplierInvoiceInNo,
  'mSupplier_Invoice_In_Date': instance.mSupplierInvoiceInDate
      ?.toIso8601String(),
  'mMoneyCurrency': instance.mMoneyCurrency,
  'mDiscount': instance.mDiscount,
  'mAmount': instance.mAmount,
  'mRemarks': instance.mRemarks,
  'mSupplier_Code': instance.mSupplierCode,
  'mSupplier_Name': instance.mSupplierName,
  'T_Supplier_Invoice_In_ID': instance.tSupplierInvoiceInId,
  'mCreated_Date': instance.mCreatedDate?.toIso8601String(),
  'mLast_Modified_Date': instance.mLastModifiedDate?.toIso8601String(),
  'mCreated_By': instance.mCreatedBy,
  'mLast_Modified_By': instance.mLastModifiedBy,
  'mEx_Ratio': instance.mExRatio,
  'mRevised': instance.mRevised,
  'mFlag': instance.mFlag,
  'mRef_Supplier_Invoice_No': instance.mRefSupplierInvoiceNo,
};

InvoiceDetail _$InvoiceDetailFromJson(Map<String, dynamic> json) =>
    InvoiceDetail(
      mItem: (json['mItem'] as num?)?.toInt(),
      mProductCode: json['mProduct_Code'] as String?,
      mProductName: json['mProduct_Name'] as String?,
      mPrice: json['mPrice'] as String?,
      mQty: json['mQty'] as String?,
      mAmount: json['mAmount'] as String?,
      mDiscount: json['mDiscount'] as String?,
      mRemarks: json['mRemarks'] as String?,
      tSupplierInvoiceInId: (json['T_Supplier_Invoice_In_ID'] as num?)?.toInt(),
      mPoDetailId: json['mPo_Detail_ID'],
      mStockCode: json['mStock_Code'] as String?,
      mUnit: json['mUnit'] as String?,
      mSupplierInvoiceInDetailId:
          (json['mSupplier_Invoice_In_Detail_ID'] as num?)?.toInt(),
      mPoNo: json['mPO_No'],
      mRevised: json['mRevised'],
      mProductContent: json['mProduct_Content'] as String?,
    );

Map<String, dynamic> _$InvoiceDetailToJson(InvoiceDetail instance) =>
    <String, dynamic>{
      'mItem': instance.mItem,
      'mProduct_Code': instance.mProductCode,
      'mProduct_Name': instance.mProductName,
      'mPrice': instance.mPrice,
      'mQty': instance.mQty,
      'mAmount': instance.mAmount,
      'mDiscount': instance.mDiscount,
      'mRemarks': instance.mRemarks,
      'T_Supplier_Invoice_In_ID': instance.tSupplierInvoiceInId,
      'mPo_Detail_ID': instance.mPoDetailId,
      'mStock_Code': instance.mStockCode,
      'mUnit': instance.mUnit,
      'mSupplier_Invoice_In_Detail_ID': instance.mSupplierInvoiceInDetailId,
      'mPO_No': instance.mPoNo,
      'mRevised': instance.mRevised,
      'mProduct_Content': instance.mProductContent,
    };
