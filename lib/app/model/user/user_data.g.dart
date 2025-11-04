// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  mName: Functions.asString(json['mName']),
  mAddress: Functions.asString(json['mAddress']),
  mTel: Functions.asString(json['mTel']),
  mEmail: Functions.asString(json['mEmail']),
  mDepartment: Functions.asString(json['mDepartment']),
  mMobilePhone: Functions.asString(json['mMobile_Phone']),
  mRemarks: Functions.asString(json['mRemarks']),
  mFax: Functions.asString(json['mFax']),
  mPassword: Functions.asString(json['mPassword']),
  mUserGroupCode: Functions.asString(json['mUserGroup_Code']),
  mCode: Functions.asString(json['mCode']),
  tUserId: Functions.asString(json['T_User_ID']),
  mNonActive: Functions.asString(json['mNon_Active']),
  mMobilePrefix: Functions.asString(json['mMobile_prefix']),
  mobile: Functions.asString(json['mobile']),
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'mName': instance.mName,
  'mAddress': instance.mAddress,
  'mTel': instance.mTel,
  'mEmail': instance.mEmail,
  'mDepartment': instance.mDepartment,
  'mMobile_Phone': instance.mMobilePhone,
  'mRemarks': instance.mRemarks,
  'mFax': instance.mFax,
  'mPassword': instance.mPassword,
  'mUserGroup_Code': instance.mUserGroupCode,
  'mCode': instance.mCode,
  'T_User_ID': instance.tUserId,
  'mNon_Active': instance.mNonActive,
  'mMobile_prefix': instance.mMobilePrefix,
  'mobile': Functions.stringToPhoneNumber(instance.mobile),
};
