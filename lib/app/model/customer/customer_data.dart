import 'package:json_annotation/json_annotation.dart';
part 'customer_data.g.dart';

@JsonSerializable()
class CustomerData {
  @JsonKey(name: "mAddress")
  final String? mAddress;
  @JsonKey(name: "mAns_Back")
  final String? mAnsBack;
  @JsonKey(name: "mCode")
  final String? mCode;
  @JsonKey(name: "mEmail")
  final String? mEmail;
  @JsonKey(name: "mFullName")
  final String? mFullName;
  @JsonKey(name: "mPhone_No")
  final String? mPhoneNo;
  @JsonKey(name: "mShipping_Marks")
  final String? mShippingMarks;
  @JsonKey(name: "mSimpleName")
  final String? mSimpleName;
  @JsonKey(name: "mSite_Marks")
  final String? mSiteMarks;
  @JsonKey(name: "mST_Credit_Limit")
  final String? mStCreditLimit;
  @JsonKey(name: "mST_Currency", defaultValue: "HKD")
  final String? mStCurrency;
  @JsonKey(name: "mST_Discount")
  final String? mStDiscount;
  @JsonKey(name: "mST_Payment_Days")
  final String? mStPaymentDays;
  @JsonKey(name: "mST_Payment_Method", defaultValue: 0)
  final int? mStPaymentMethod;
  @JsonKey(name: "mST_Payment_Term")
  final String? mStPaymentTerm;
  @JsonKey(name: "mST_Price_Term")
  final String? mStPriceTerm;
  @JsonKey(name: "mTelex")
  final String? mTelex;
  @JsonKey(name: "mFax_No")
  final String? mFaxNo;
  @JsonKey(name: "T_Customer_ID")
  final int? tCustomerId;
  @JsonKey(name: "mRemarks")
  final String? mRemarks;
  @JsonKey(name: "mBirthday")
  final String? mBirthday;
  @JsonKey(name: "mOccupation")
  final String? mOccupation;
  @JsonKey(name: "mMarried", defaultValue: 0)
  final int? mMarried;
  @JsonKey(name: "mBirthday_Year")
  final int? mBirthdayYear;
  @JsonKey(name: "mBirthday_Month")
  final int? mBirthdayMonth;
  @JsonKey(name: "mBirthday_Day")
  final int? mBirthdayDay;
  @JsonKey(name: "mSex", defaultValue: 0)
  final int? mSex;
  @JsonKey(name: "mNon_Active", defaultValue: 0)
  final int? mNonActive;
  @JsonKey(name: "mExpiry_Date")
  final DateTime? mExpiryDate;
  @JsonKey(name: "mSimple_Discount", defaultValue: 0)
  final int? mSimpleDiscount;
  @JsonKey(name: "mDeposit")
  final dynamic mDeposit;
  @JsonKey(name: "mCustomer_Type")
  final String? mCustomerType;
  @JsonKey(name: "mCustomer_Note")
  final dynamic mCustomerNote;
  @JsonKey(name: "mCreateDate")
  final DateTime? mCreateDate;
  @JsonKey(name: "mCustomer_Reference")
  final dynamic mCustomerReference;
  @JsonKey(name: "mInfoNA")
  final int? mInfoNa;
  @JsonKey(name: "mCardNo")
  final dynamic mCardNo;
  @JsonKey(name: "mPassword")
  final String? mPassword;
  @JsonKey(name: "pushinfo", defaultValue: 0)
  final int? pushinfo;

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
    dynamic mAddress,
    dynamic mAnsBack,
    String? mCode,
    String? mEmail,
    dynamic mFullName,
    String? mPhoneNo,
    dynamic mShippingMarks,
    String? mSimpleName,
    dynamic mSiteMarks,
    dynamic mStCreditLimit,
    dynamic mStCurrency,
    dynamic mStDiscount,
    dynamic mStPaymentDays,
    dynamic mStPaymentMethod,
    dynamic mStPaymentTerm,
    dynamic mStPriceTerm,
    dynamic mTelex,
    dynamic mFaxNo,
    int? tCustomerId,
    dynamic mRemarks,
    dynamic mBirthday,
    dynamic mOccupation,
    dynamic mMarried,
    int? mBirthdayYear,
    int? mBirthdayMonth,
    int? mBirthdayDay,
    int? mSex,
    dynamic mNonActive,
    dynamic mExpiryDate,
    dynamic mSimpleDiscount,
    dynamic mDeposit,
    dynamic mCustomerType,
    dynamic mCustomerNote,
    DateTime? mCreateDate,
    dynamic mCustomerReference,
    int? mInfoNa,
    dynamic mCardNo,
    String? mPassword,
    int? pushinfo,
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
