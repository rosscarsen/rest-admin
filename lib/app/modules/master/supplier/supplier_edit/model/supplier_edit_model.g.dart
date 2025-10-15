// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierEditModel _$SupplierEditModelFromJson(Map<String, dynamic> json) =>
    SupplierEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : SupplierEditResult.fromJson(
              json['apiResult'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SupplierEditModelToJson(SupplierEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

SupplierEditResult _$SupplierEditResultFromJson(Map<String, dynamic> json) =>
    SupplierEditResult(
      mAddress: Functions.asString(json['mAddress']),
      mAnsBack: Functions.asString(json['mAns_Back']),
      mCode: Functions.asString(json['mCode']),
      mContact: Functions.asString(json['mContact']),
      mFaxNo: Functions.asString(json['mFax_No']),
      mFullName: Functions.asString(json['mFullName']),
      mPhoneNo: Functions.asString(json['mPhone_No']),
      mSimpleName: Functions.asString(json['mSimpleName']),
      mStCurrency: Functions.asString(json['mST_Currency']),
      mStPaymentDays: Functions.asString(json['mST_Payment_Days']),
      mStDiscount: Functions.asString(json['mST_Discount']),
      mStPaymentMethod: Functions.asString(json['mST_Payment_Method']),
      mStPaymentTerm: Functions.asString(json['mST_Payment_Term']),
      mTelex: Functions.asString(json['mTelex']),
      tSupplierId: Functions.asString(json['T_Supplier_ID']),
      mEmail: Functions.asString(json['mEmail']),
      mRemarks: Functions.asString(json['mRemarks']),
      mNonActive: Functions.asString(json['mNon_Active']),
      currency: (json['currency'] as List<dynamic>?)
          ?.map((e) => CurrencyData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupplierEditResultToJson(SupplierEditResult instance) =>
    <String, dynamic>{
      'mAddress': instance.mAddress,
      'mAns_Back': instance.mAnsBack,
      'mCode': instance.mCode,
      'mContact': instance.mContact,
      'mFax_No': instance.mFaxNo,
      'mFullName': instance.mFullName,
      'mPhone_No': instance.mPhoneNo,
      'mSimpleName': instance.mSimpleName,
      'mST_Currency': instance.mStCurrency,
      'mST_Payment_Days': instance.mStPaymentDays,
      'mST_Discount': instance.mStDiscount,
      'mST_Payment_Method': instance.mStPaymentMethod,
      'mST_Payment_Term': instance.mStPaymentTerm,
      'mTelex': instance.mTelex,
      'T_Supplier_ID': instance.tSupplierId,
      'mEmail': instance.mEmail,
      'mRemarks': instance.mRemarks,
      'mNon_Active': instance.mNonActive,
      'currency': instance.currency?.map((e) => e.toJson()).toList(),
    };
