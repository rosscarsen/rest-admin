import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';

part 'customer_data.g.dart';

@JsonSerializable()
class CustomerData {
  @JsonKey(name: "mAddress", fromJson: Functions.asString)
  String? mAddress;
  @JsonKey(name: "mAns_Back", fromJson: Functions.asString)
  String? mAnsBack;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "mEmail", fromJson: Functions.asString)
  String? mEmail;
  @JsonKey(name: "mFullName", fromJson: Functions.asString)
  String? mFullName;
  @JsonKey(name: "mPhone_No", fromJson: Functions.asString, toJson: Functions.stringToPhoneNumber)
  String? mPhoneNo;
  @JsonKey(name: "mShipping_Marks", fromJson: Functions.asString)
  String? mShippingMarks;
  @JsonKey(name: "mSimpleName", fromJson: Functions.asString)
  String? mSimpleName;
  @JsonKey(name: "mSite_Marks", fromJson: Functions.asString)
  String? mSiteMarks;
  @JsonKey(name: "mST_Credit_Limit", fromJson: Functions.asString)
  String? mStCreditLimit;
  @JsonKey(name: "mST_Currency", defaultValue: "HKD", fromJson: Functions.asString)
  String? mStCurrency;
  @JsonKey(name: "mST_Discount", fromJson: Functions.asString)
  String? mStDiscount;
  @JsonKey(name: "mST_Payment_Days", fromJson: Functions.asString)
  String? mStPaymentDays;
  @JsonKey(name: "mST_Payment_Method", defaultValue: "0", fromJson: Functions.asString)
  String? mStPaymentMethod;
  @JsonKey(name: "mST_Payment_Term", fromJson: Functions.asString)
  String? mStPaymentTerm;
  @JsonKey(name: "mST_Price_Term", fromJson: Functions.asString)
  String? mStPriceTerm;
  @JsonKey(name: "mTelex", fromJson: Functions.asString)
  String? mTelex;
  @JsonKey(name: "mFax_No", fromJson: Functions.asString)
  String? mFaxNo;
  @JsonKey(name: "T_Customer_ID", fromJson: Functions.asString)
  String? tCustomerId;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mBirthday", fromJson: Functions.asString)
  String? mBirthday;
  @JsonKey(name: "mOccupation", fromJson: Functions.asString)
  String? mOccupation;
  @JsonKey(name: "mMarried", defaultValue: "0", fromJson: Functions.asString)
  String? mMarried;
  @JsonKey(name: "mBirthday_Year", fromJson: Functions.asString)
  String? mBirthdayYear;
  @JsonKey(name: "mBirthday_Month", fromJson: Functions.asString)
  String? mBirthdayMonth;
  @JsonKey(name: "mBirthday_Day", fromJson: Functions.asString)
  String? mBirthdayDay;
  @JsonKey(name: "mSex", defaultValue: "0", fromJson: Functions.asString)
  String? mSex;
  @JsonKey(name: "mNon_Active", defaultValue: "0", fromJson: Functions.asString)
  String? mNonActive;
  @JsonKey(name: "mExpiry_Date", fromJson: Functions.asString)
  String? mExpiryDate;
  @JsonKey(name: "mSimple_Discount", defaultValue: "0", fromJson: Functions.asString)
  String? mSimpleDiscount;
  @JsonKey(name: "mDeposit", fromJson: Functions.asString, toJson: Functions.formatAmount)
  String? mDeposit;
  @JsonKey(name: "mCustomer_Type", fromJson: Functions.asString)
  String? mCustomerType;
  @JsonKey(name: "mCustomer_Note", fromJson: Functions.asString)
  dynamic mCustomerNote;
  @JsonKey(name: "mCreateDate", fromJson: Functions.asString)
  String? mCreateDate;
  @JsonKey(name: "mCustomer_Reference", fromJson: Functions.asString)
  dynamic mCustomerReference;
  @JsonKey(name: "mInfoNA", fromJson: Functions.asString)
  String? mInfoNa;
  @JsonKey(name: "mCardNo", fromJson: Functions.asString)
  String? mCardNo;
  @JsonKey(name: "mPassword", fromJson: Functions.asString)
  String? mPassword;
  @JsonKey(name: "pushinfo", defaultValue: "0", fromJson: Functions.asString)
  String? pushinfo;

  CustomerData({
    this.mAddress,
    this.mAnsBack,
    this.mCode,
    this.mEmail,
    this.mFullName,
    this.mPhoneNo,
    this.mShippingMarks,
    this.mSimpleName,
    this.mSiteMarks,
    this.mStCreditLimit,
    this.mStCurrency,
    this.mStDiscount,
    this.mStPaymentDays,
    this.mStPaymentMethod,
    this.mStPaymentTerm,
    this.mStPriceTerm,
    this.mTelex,
    this.mFaxNo,
    this.tCustomerId,
    this.mRemarks,
    this.mBirthday,
    this.mOccupation,
    this.mMarried,
    this.mBirthdayYear,
    this.mBirthdayMonth,
    this.mBirthdayDay,
    this.mSex,
    this.mNonActive,
    this.mExpiryDate,
    this.mSimpleDiscount,
    this.mDeposit,
    this.mCustomerType,
    this.mCustomerNote,
    this.mCreateDate,
    this.mCustomerReference,
    this.mInfoNa,
    this.mCardNo,
    this.mPassword,
    this.pushinfo,
  });

  CustomerData copyWith({
    String? mAddress,
    String? mAnsBack,
    String? mCode,
    String? mEmail,
    String? mFullName,
    String? mPhoneNo,
    String? mShippingMarks,
    String? mSimpleName,
    String? mSiteMarks,
    String? mStCreditLimit,
    String? mStCurrency,
    String? mStDiscount,
    String? mStPaymentDays,
    String? mStPaymentMethod,
    String? mStPaymentTerm,
    String? mStPriceTerm,
    String? mTelex,
    String? mFaxNo,
    String? tCustomerId,
    String? mRemarks,
    String? mBirthday,
    String? mOccupation,
    String? mMarried,
    String? mBirthdayYear,
    String? mBirthdayMonth,
    String? mBirthdayDay,
    String? mSex,
    String? mNonActive,
    String? mExpiryDate,
    String? mSimpleDiscount,
    String? mDeposit,
    String? mCustomerType,
    String? mCustomerNote,
    String? mCreateDate,
    String? mCustomerReference,
    String? mInfoNa,
    String? mCardNo,
    String? mPassword,
    String? pushinfo,
  }) => CustomerData(
    mAddress: mAddress ?? this.mAddress,
    mAnsBack: mAnsBack ?? this.mAnsBack,
    mCode: mCode ?? this.mCode,
    mEmail: mEmail ?? this.mEmail,
    mFullName: mFullName ?? this.mFullName,
    mPhoneNo: mPhoneNo ?? this.mPhoneNo,
    mShippingMarks: mShippingMarks ?? this.mShippingMarks,
    mSimpleName: mSimpleName ?? this.mSimpleName,
    mSiteMarks: mSiteMarks ?? this.mSiteMarks,
    mStCreditLimit: mStCreditLimit ?? this.mStCreditLimit,
    mStCurrency: mStCurrency ?? this.mStCurrency,
    mStDiscount: mStDiscount ?? this.mStDiscount,
    mStPaymentDays: mStPaymentDays ?? this.mStPaymentDays,
    mStPaymentMethod: mStPaymentMethod ?? this.mStPaymentMethod,
    mStPaymentTerm: mStPaymentTerm ?? this.mStPaymentTerm,
    mStPriceTerm: mStPriceTerm ?? this.mStPriceTerm,
    mTelex: mTelex ?? this.mTelex,
    mFaxNo: mFaxNo ?? this.mFaxNo,
    tCustomerId: tCustomerId ?? this.tCustomerId,
    mRemarks: mRemarks ?? this.mRemarks,
    mBirthday: mBirthday ?? this.mBirthday,
    mOccupation: mOccupation ?? this.mOccupation,
    mMarried: mMarried ?? this.mMarried,
    mBirthdayYear: mBirthdayYear ?? this.mBirthdayYear,
    mBirthdayMonth: mBirthdayMonth ?? this.mBirthdayMonth,
    mBirthdayDay: mBirthdayDay ?? this.mBirthdayDay,
    mSex: mSex ?? this.mSex,
    mNonActive: mNonActive ?? this.mNonActive,
    mExpiryDate: mExpiryDate ?? this.mExpiryDate,
    mSimpleDiscount: mSimpleDiscount ?? this.mSimpleDiscount,
    mDeposit: mDeposit ?? this.mDeposit,
    mCustomerType: mCustomerType ?? this.mCustomerType,
    mCustomerNote: mCustomerNote ?? this.mCustomerNote,
    mCreateDate: mCreateDate ?? this.mCreateDate,
    mCustomerReference: mCustomerReference ?? this.mCustomerReference,
    mInfoNa: mInfoNa ?? this.mInfoNa,
    mCardNo: mCardNo ?? this.mCardNo,
    mPassword: mPassword ?? this.mPassword,
    pushinfo: pushinfo ?? this.pushinfo,
  );

  factory CustomerData.fromJson(Map<String, dynamic> json) => _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);
}
