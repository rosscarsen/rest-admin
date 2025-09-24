// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierData _$SupplierDataFromJson(Map<String, dynamic> json) => SupplierData(
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
);

Map<String, dynamic> _$SupplierDataToJson(SupplierData instance) =>
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
    };
