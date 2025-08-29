// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
  mAddress: Functions.asString(json['mAddress']),
  mAnsBack: Functions.asString(json['mAns_Back']),
  mCode: Functions.asString(json['mCode']),
  mEmail: Functions.asString(json['mEmail']),
  mFullName: Functions.asString(json['mFullName']),
  mPhoneNo: Functions.asString(json['mPhone_No']),
  mShippingMarks: Functions.asString(json['mShipping_Marks']),
  mSimpleName: Functions.asString(json['mSimpleName']),
  mSiteMarks: Functions.asString(json['mSite_Marks']),
  mStCreditLimit: Functions.asString(json['mST_Credit_Limit']),
  mStCurrency: json['mST_Currency'] == null
      ? 'HKD'
      : Functions.asString(json['mST_Currency']),
  mStDiscount: Functions.asString(json['mST_Discount']),
  mStPaymentDays: Functions.asString(json['mST_Payment_Days']),
  mStPaymentMethod: json['mST_Payment_Method'] == null
      ? '0'
      : Functions.asString(json['mST_Payment_Method']),
  mStPaymentTerm: Functions.asString(json['mST_Payment_Term']),
  mStPriceTerm: Functions.asString(json['mST_Price_Term']),
  mTelex: Functions.asString(json['mTelex']),
  mFaxNo: Functions.asString(json['mFax_No']),
  tCustomerId: Functions.asString(json['T_Customer_ID']),
  mRemarks: Functions.asString(json['mRemarks']),
  mBirthday: Functions.asString(json['mBirthday']),
  mOccupation: Functions.asString(json['mOccupation']),
  mMarried: json['mMarried'] == null
      ? '0'
      : Functions.asString(json['mMarried']),
  mBirthdayYear: Functions.asString(json['mBirthday_Year']),
  mBirthdayMonth: Functions.asString(json['mBirthday_Month']),
  mBirthdayDay: Functions.asString(json['mBirthday_Day']),
  mSex: json['mSex'] == null ? '0' : Functions.asString(json['mSex']),
  mNonActive: json['mNon_Active'] == null
      ? '0'
      : Functions.asString(json['mNon_Active']),
  mExpiryDate: Functions.asString(json['mExpiry_Date']),
  mSimpleDiscount: json['mSimple_Discount'] == null
      ? '0'
      : Functions.asString(json['mSimple_Discount']),
  mDeposit: Functions.asString(json['mDeposit']),
  mCustomerType: Functions.asString(json['mCustomer_Type']),
  mCustomerNote: Functions.asString(json['mCustomer_Note']),
  mCreateDate: Functions.asString(json['mCreateDate']),
  mCustomerReference: Functions.asString(json['mCustomer_Reference']),
  mInfoNa: Functions.asString(json['mInfoNA']),
  mCardNo: Functions.asString(json['mCardNo']),
  mPassword: Functions.asString(json['mPassword']),
  pushinfo: json['pushinfo'] == null
      ? '0'
      : Functions.asString(json['pushinfo']),
);

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'mAddress': instance.mAddress,
      'mAns_Back': instance.mAnsBack,
      'mCode': instance.mCode,
      'mEmail': instance.mEmail,
      'mFullName': instance.mFullName,
      'mPhone_No': instance.mPhoneNo,
      'mShipping_Marks': instance.mShippingMarks,
      'mSimpleName': instance.mSimpleName,
      'mSite_Marks': instance.mSiteMarks,
      'mST_Credit_Limit': instance.mStCreditLimit,
      'mST_Currency': instance.mStCurrency,
      'mST_Discount': instance.mStDiscount,
      'mST_Payment_Days': instance.mStPaymentDays,
      'mST_Payment_Method': instance.mStPaymentMethod,
      'mST_Payment_Term': instance.mStPaymentTerm,
      'mST_Price_Term': instance.mStPriceTerm,
      'mTelex': instance.mTelex,
      'mFax_No': instance.mFaxNo,
      'T_Customer_ID': instance.tCustomerId,
      'mRemarks': instance.mRemarks,
      'mBirthday': instance.mBirthday,
      'mOccupation': instance.mOccupation,
      'mMarried': instance.mMarried,
      'mBirthday_Year': instance.mBirthdayYear,
      'mBirthday_Month': instance.mBirthdayMonth,
      'mBirthday_Day': instance.mBirthdayDay,
      'mSex': instance.mSex,
      'mNon_Active': instance.mNonActive,
      'mExpiry_Date': instance.mExpiryDate,
      'mSimple_Discount': instance.mSimpleDiscount,
      'mDeposit': instance.mDeposit,
      'mCustomer_Type': instance.mCustomerType,
      'mCustomer_Note': instance.mCustomerNote,
      'mCreateDate': instance.mCreateDate,
      'mCustomer_Reference': instance.mCustomerReference,
      'mInfoNA': instance.mInfoNa,
      'mCardNo': instance.mCardNo,
      'mPassword': instance.mPassword,
      'pushinfo': instance.pushinfo,
    };
