// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerContact _$CustomerContactFromJson(Map<String, dynamic> json) =>
    CustomerContact(
      mAddress: Functions.asString(json['mAddress']),
      mDepartment: Functions.asString(json['mDepartment']),
      mEmail: Functions.asString(json['mEmail']),
      mFax: Functions.asString(json['mFax']),
      mMobilePhone: Functions.asString(json['mMobile_Phone']),
      mTel: Functions.asString(json['mTel']),
      mRemarks: Functions.asString(json['mRemarks']),
      mName: Functions.asString(json['mName']),
      mItem: Functions.asString(json['mItem']),
      tCustomerId: Functions.asString(json['T_Customer_ID']),
      customerContactDefault: Functions.asString(json['default']),
    );

Map<String, dynamic> _$CustomerContactToJson(CustomerContact instance) =>
    <String, dynamic>{
      'mAddress': instance.mAddress,
      'mDepartment': instance.mDepartment,
      'mEmail': instance.mEmail,
      'mFax': instance.mFax,
      'mMobile_Phone': instance.mMobilePhone,
      'mTel': instance.mTel,
      'mRemarks': instance.mRemarks,
      'mName': instance.mName,
      'mItem': instance.mItem,
      'T_Customer_ID': instance.tCustomerId,
      'default': instance.customerContactDefault,
    };
