// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  String? mCategory;
  String? mParent;
  String? mDescription;
  int? tCategoryId;
  String? mDiscount;
  String? mDateTimeStart;
  String? mDateTimeEnd;
  String? mPrinter;
  int? mContinue;
  String? mTimeStart;
  String? mTimeEnd;
  int? mTimeZone;
  String? mStockCode;
  int? mHide;
  int? mSetColor;
  int? mPrintType;
  dynamic mPrintTemp;
  int? mQty;
  int? mHidden;
  int? mNonWebHide;
  String? mBdlPrinter;
  int? mCustomerSelfHelpHide;
  int? mTakeawayDisplay;
  int? mKiosk;
  int? mNonContinue;
  int? mSort;
  int? tier;
  List<CategoryModel>? children;

  CategoryModel({
    this.mCategory,
    this.mParent,
    this.mDescription,
    this.tCategoryId,
    this.mDiscount,
    this.mDateTimeStart,
    this.mDateTimeEnd,
    this.mPrinter,
    this.mContinue,
    this.mTimeStart,
    this.mTimeEnd,
    this.mTimeZone,
    this.mStockCode,
    this.mHide,
    this.mSetColor,
    this.mPrintType,
    this.mPrintTemp,
    this.mQty,
    this.mHidden,
    this.mNonWebHide,
    this.mBdlPrinter,
    this.mCustomerSelfHelpHide,
    this.mTakeawayDisplay,
    this.mKiosk,
    this.mNonContinue,
    this.mSort,
    this.tier,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    mCategory: json["mCategory"],
    mParent: json["mParent"],
    mDescription: json["mDescription"],
    tCategoryId: json["T_Category_ID"],
    mDiscount: json["mDiscount"],
    mDateTimeStart: json["mDateTimeStart"],
    mDateTimeEnd: json["mDateTimeEnd"],
    mPrinter: json["mPrinter"],
    mContinue: json["mContinue"],
    mTimeStart: json["mTimeStart"],
    mTimeEnd: json["mTimeEnd"],
    mTimeZone: json["mTimeZone"],
    mStockCode: json["mStockCode"],
    mHide: json["mHide"],
    mSetColor: json["mSetColor"],
    mPrintType: json["mPrintType"],
    mPrintTemp: json["mPrintTemp"],
    mQty: json["mQty"],
    mHidden: json["mHidden"],
    mNonWebHide: json["mNon_WebHide"],
    mBdlPrinter: json["mBDLPrinter"],
    mCustomerSelfHelpHide: json["mCustomer_self_help_Hide"],
    mTakeawayDisplay: json["mTakeaway_display"],
    mKiosk: json["mKiosk"],
    mNonContinue: json["mNonContinue"],
    mSort: json["mSort"],
    tier: json["tier"],
    children: json["children"] == null
        ? []
        : List<CategoryModel>.from(json["children"]!.map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mCategory": mCategory,
    "mParent": mParent,
    "mDescription": mDescription,
    "T_Category_ID": tCategoryId,
    "mDiscount": mDiscount,
    "mDateTimeStart": mDateTimeStart,
    "mDateTimeEnd": mDateTimeEnd,
    "mPrinter": mPrinter,
    "mContinue": mContinue,
    "mTimeStart": mTimeStart,
    "mTimeEnd": mTimeEnd,
    "mTimeZone": mTimeZone,
    "mStockCode": mStockCode,
    "mHide": mHide,
    "mSetColor": mSetColor,
    "mPrintType": mPrintType,
    "mPrintTemp": mPrintTemp,
    "mQty": mQty,
    "mHidden": mHidden,
    "mNon_WebHide": mNonWebHide,
    "mBDLPrinter": mBdlPrinter,
    "mCustomer_self_help_Hide": mCustomerSelfHelpHide,
    "mTakeaway_display": mTakeawayDisplay,
    "mKiosk": mKiosk,
    "mNonContinue": mNonContinue,
    "mSort": mSort,
    "tier": tier,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'CategoryModel(mCategory: $mCategory, mParent: $mParent, mDescription: $mDescription, tCategoryId: $tCategoryId, mDiscount: $mDiscount, mDateTimeStart: $mDateTimeStart, mDateTimeEnd: $mDateTimeEnd, mPrinter: $mPrinter, mContinue: $mContinue, mTimeStart: $mTimeStart, mTimeEnd: $mTimeEnd, mTimeZone: $mTimeZone, mStockCode: $mStockCode, mHide: $mHide, mSetColor: $mSetColor, mPrintType: $mPrintType, mPrintTemp: $mPrintTemp, mQty: $mQty, mHidden: $mHidden, mNonWebHide: $mNonWebHide, mBdlPrinter: $mBdlPrinter, mCustomerSelfHelpHide: $mCustomerSelfHelpHide, mTakeawayDisplay: $mTakeawayDisplay, mKiosk: $mKiosk, mNonContinue: $mNonContinue, mSort: $mSort, tier: $tier, children: $children)';
  }

  CategoryModel copyWith({
    String? mCategory,
    String? mParent,
    String? mDescription,
    int? tCategoryId,
    String? mDiscount,
    String? mDateTimeStart,
    String? mDateTimeEnd,
    String? mPrinter,
    int? mContinue,
    String? mTimeStart,
    String? mTimeEnd,
    int? mTimeZone,
    String? mStockCode,
    int? mHide,
    int? mSetColor,
    int? mPrintType,
    String? mPrintTemp,
    int? mQty,
    int? mHidden,
    int? mNonWebHide,
    String? mBdlPrinter,
    int? mCustomerSelfHelpHide,
    int? mTakeawayDisplay,
    int? mKiosk,
    int? mNonContinue,
    int? mSort,
    int? tier,
    List<CategoryModel>? children,
  }) {
    return CategoryModel(
      mCategory: mCategory ?? this.mCategory,
      mParent: mParent ?? this.mParent,
      mDescription: mDescription ?? this.mDescription,
      tCategoryId: tCategoryId ?? this.tCategoryId,
      mDiscount: mDiscount ?? this.mDiscount,
      mDateTimeStart: mDateTimeStart ?? this.mDateTimeStart,
      mDateTimeEnd: mDateTimeEnd ?? this.mDateTimeEnd,
      mPrinter: mPrinter ?? this.mPrinter,
      mContinue: mContinue ?? this.mContinue,
      mTimeStart: mTimeStart ?? this.mTimeStart,
      mTimeEnd: mTimeEnd ?? this.mTimeEnd,
      mTimeZone: mTimeZone ?? this.mTimeZone,
      mStockCode: mStockCode ?? this.mStockCode,
      mHide: mHide ?? this.mHide,
      mSetColor: mSetColor ?? this.mSetColor,
      mPrintType: mPrintType ?? this.mPrintType,
      mPrintTemp: mPrintTemp ?? this.mPrintTemp,
      mQty: mQty ?? this.mQty,
      mHidden: mHidden ?? this.mHidden,
      mNonWebHide: mNonWebHide ?? this.mNonWebHide,
      mBdlPrinter: mBdlPrinter ?? this.mBdlPrinter,
      mCustomerSelfHelpHide: mCustomerSelfHelpHide ?? this.mCustomerSelfHelpHide,
      mTakeawayDisplay: mTakeawayDisplay ?? this.mTakeawayDisplay,
      mKiosk: mKiosk ?? this.mKiosk,
      mNonContinue: mNonContinue ?? this.mNonContinue,
      mSort: mSort ?? this.mSort,
      tier: tier ?? this.tier,
      children: children ?? this.children,
    );
  }

  void copyFrom(CategoryModel model) {
    mCategory = model.mCategory;
    mParent = model.mParent;
    mDescription = model.mDescription;
    tCategoryId = model.tCategoryId;
    mDiscount = model.mDiscount;
    mDateTimeStart = model.mDateTimeStart;
    mDateTimeEnd = model.mDateTimeEnd;
    mPrinter = model.mPrinter;
    mContinue = model.mContinue;
    mTimeStart = model.mTimeStart;
    mTimeEnd = model.mTimeEnd;
    mTimeZone = model.mTimeZone;
    mStockCode = model.mStockCode;
    mHide = model.mHide;
    mSetColor = model.mSetColor;
    mPrintType = model.mPrintType;
    mPrintTemp = model.mPrintTemp;
    mQty = model.mQty;
    mHidden = model.mHidden;
    mNonWebHide = model.mNonWebHide;
    mBdlPrinter = model.mBdlPrinter;
    mCustomerSelfHelpHide = model.mCustomerSelfHelpHide;
    mTakeawayDisplay = model.mTakeawayDisplay;
    mKiosk = model.mKiosk;
    mNonContinue = model.mNonContinue;
    mSort = model.mSort;
    tier = model.tier;
    children = model.children;
  }
}
