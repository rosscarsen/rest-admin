// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final productExportModel = productExportModelFromJson(jsonString);

import 'dart:convert';

ProductExportModel productExportModelFromJson(String str) => ProductExportModel.fromJson(json.decode(str));

String productExportModelToJson(ProductExportModel data) => json.encode(data.toJson());

class ProductExportModel {
  List<ProductExportResult>? result;
  String? msg;
  int? status;

  ProductExportModel({this.result, this.msg, this.status});

  factory ProductExportModel.fromJson(Map<String, dynamic> json) => ProductExportModel(
    result:
        json["result"] == null
            ? []
            : List<ProductExportResult>.from(json["result"]!.map((x) => ProductExportResult.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class ProductExportResult {
  String? mCode;
  String? mRefCode;
  String? mDesc1;
  String? mDesc2;
  String? mUnit;
  String? mMeasurement;
  String? mCategory1;
  String? mCategory2;
  String? mCategory3;
  String? mMaxLevel;
  String? mMinLevel;
  String? mBrand;
  String? mColor;
  String? mSize;
  String? mAvPrice;
  String? mAvCost;
  DateTime? mDateCreate;
  String? mLatPrice;
  String? mLatCost;
  DateTime? mDateModify;
  String? mModel;
  String? mSupplierCode;
  String? mPicturePath;
  String? mTradePrice;
  dynamic mRetailPrice;
  String? mBottomPrice;
  String? mMemberPrice;
  int? tProductId;
  String? mRemarks;
  int? mNonDiscount;
  int? mNonStock;
  dynamic mOriginalPrice;
  int? mBundleSales;
  int? mTimes;
  int? mPrePaid;
  int? mNonActived;
  String? mStandardCost;
  String? mExpiryDate;
  int? mNonCharge;
  String? mPrice1;
  dynamic mPrice2;
  dynamic mPrice3;
  String? mStockCode;
  int? mSetOption;
  int? mSoldOut;
  int? mNonWebHide;
  dynamic mWebRemarks;
  int? mNewest;
  int? mSpecials;
  dynamic mIsStandPrice;
  String? setmenu;
  int? sort;
  String? mBarcode;
  String? mDiscount1;
  dynamic mDiscount2;
  dynamic mDiscount3;
  dynamic mPrice4;
  dynamic mDiscount4;
  dynamic mPrice5;
  dynamic mDiscount5;
  dynamic mPrice6;
  dynamic mDiscount6;
  String? mQty;
  String? mPCode;

  ProductExportResult({
    this.mCode,
    this.mRefCode,
    this.mDesc1,
    this.mDesc2,
    this.mUnit,
    this.mMeasurement,
    this.mCategory1,
    this.mCategory2,
    this.mCategory3,
    this.mMaxLevel,
    this.mMinLevel,
    this.mBrand,
    this.mColor,
    this.mSize,
    this.mAvPrice,
    this.mAvCost,
    this.mDateCreate,
    this.mLatPrice,
    this.mLatCost,
    this.mDateModify,
    this.mModel,
    this.mSupplierCode,
    this.mPicturePath,
    this.mTradePrice,
    this.mRetailPrice,
    this.mBottomPrice,
    this.mMemberPrice,
    this.tProductId,
    this.mRemarks,
    this.mNonDiscount,
    this.mNonStock,
    this.mOriginalPrice,
    this.mBundleSales,
    this.mTimes,
    this.mPrePaid,
    this.mNonActived,
    this.mStandardCost,
    this.mExpiryDate,
    this.mNonCharge,
    this.mPrice1,
    this.mPrice2,
    this.mPrice3,
    this.mStockCode,
    this.mSetOption,
    this.mSoldOut,
    this.mNonWebHide,
    this.mWebRemarks,
    this.mNewest,
    this.mSpecials,
    this.mIsStandPrice,
    this.setmenu,
    this.sort,
    this.mBarcode,
    this.mDiscount1,
    this.mDiscount2,
    this.mDiscount3,
    this.mPrice4,
    this.mDiscount4,
    this.mPrice5,
    this.mDiscount5,
    this.mPrice6,
    this.mDiscount6,
    this.mQty,
    this.mPCode,
  });

  factory ProductExportResult.fromJson(Map<String, dynamic> json) => ProductExportResult(
    mCode: json["mCode"],
    mRefCode: json["mRef_Code"],
    mDesc1: json["mDesc1"],
    mDesc2: json["mDesc2"],
    mUnit: json["mUnit"],
    mMeasurement: json["mMeasurement"],
    mCategory1: json["mCategory1"],
    mCategory2: json["mCategory2"],
    mCategory3: json["mCategory3"],
    mMaxLevel: json["mMax_Level"],
    mMinLevel: json["mMin_Level"],
    mBrand: json["mBrand"],
    mColor: json["mColor"],
    mSize: json["mSize"],
    mAvPrice: json["mAv_Price"],
    mAvCost: json["mAv_Cost"],
    mDateCreate: json["mDate_Create"] == null ? null : DateTime.parse(json["mDate_Create"]),
    mLatPrice: json["mLat_Price"],
    mLatCost: json["mLat_Cost"],
    mDateModify: json["mDate_Modify"] == null ? null : DateTime.parse(json["mDate_Modify"]),
    mModel: json["mModel"],
    mSupplierCode: json["mSupplier_Code"],
    mPicturePath: json["mPicture_Path"],
    mTradePrice: json["mTrade_Price"],
    mRetailPrice: json["mRetail_Price"],
    mBottomPrice: json["mBottom_Price"],
    mMemberPrice: json["mMember_Price"],
    tProductId: json["T_Product_ID"],
    mRemarks: json["mRemarks"],
    mNonDiscount: json["mNon_Discount"],
    mNonStock: json["mNon_Stock"],
    mOriginalPrice: json["mOriginal_Price"],
    mBundleSales: json["mBundle_Sales"],
    mTimes: json["mTimes"],
    mPrePaid: json["mPrePaid"],
    mNonActived: json["mNonActived"],
    mStandardCost: json["mStandard_Cost"],
    mExpiryDate: json["mExpiryDate"],
    mNonCharge: json["mNonCharge"],
    mPrice1: json["mPrice1"],
    mPrice2: json["mPrice2"],
    mPrice3: json["mPrice3"],
    mStockCode: json["mStockCode"],
    mSetOption: json["mSetOption"],
    mSoldOut: json["mSoldOut"],
    mNonWebHide: json["mNon_WebHide"],
    mWebRemarks: json["mWeb_Remarks"],
    mNewest: json["mNewest"],
    mSpecials: json["mSpecials"],
    mIsStandPrice: json["mIsStandPrice"],
    setmenu: json["setmenu"],
    sort: json["sort"],
    mBarcode: json["mBarcode"],
    mDiscount1: json["mDiscount1"],
    mDiscount2: json["mDiscount2"],
    mDiscount3: json["mDiscount3"],
    mPrice4: json["mPrice4"],
    mDiscount4: json["mDiscount4"],
    mPrice5: json["mPrice5"],
    mDiscount5: json["mDiscount5"],
    mPrice6: json["mPrice6"],
    mDiscount6: json["mDiscount6"],
    mQty: json["mQty"],
    mPCode: json["mPCode"],
  );

  Map<String, dynamic> toJson() => {
    "mCode": mCode,
    "mRef_Code": mRefCode,
    "mDesc1": mDesc1,
    "mDesc2": mDesc2,
    "mUnit": mUnit,
    "mMeasurement": mMeasurement,
    "mCategory1": mCategory1,
    "mCategory2": mCategory2,
    "mCategory3": mCategory3,
    "mMax_Level": mMaxLevel,
    "mMin_Level": mMinLevel,
    "mBrand": mBrand,
    "mColor": mColor,
    "mSize": mSize,
    "mAv_Price": mAvPrice,
    "mAv_Cost": mAvCost,
    "mDate_Create": mDateCreate?.toIso8601String(),
    "mLat_Price": mLatPrice,
    "mLat_Cost": mLatCost,
    "mDate_Modify": mDateModify?.toIso8601String(),
    "mModel": mModel,
    "mSupplier_Code": mSupplierCode,
    "mPicture_Path": mPicturePath,
    "mTrade_Price": mTradePrice,
    "mRetail_Price": mRetailPrice,
    "mBottom_Price": mBottomPrice,
    "mMember_Price": mMemberPrice,
    "T_Product_ID": tProductId,
    "mRemarks": mRemarks,
    "mNon_Discount": mNonDiscount,
    "mNon_Stock": mNonStock,
    "mOriginal_Price": mOriginalPrice,
    "mBundle_Sales": mBundleSales,
    "mTimes": mTimes,
    "mPrePaid": mPrePaid,
    "mNonActived": mNonActived,
    "mStandard_Cost": mStandardCost,
    "mExpiryDate": mExpiryDate,
    "mNonCharge": mNonCharge,
    "mPrice1": mPrice1,
    "mPrice2": mPrice2,
    "mPrice3": mPrice3,
    "mStockCode": mStockCode,
    "mSetOption": mSetOption,
    "mSoldOut": mSoldOut,
    "mNon_WebHide": mNonWebHide,
    "mWeb_Remarks": mWebRemarks,
    "mNewest": mNewest,
    "mSpecials": mSpecials,
    "mIsStandPrice": mIsStandPrice,
    "setmenu": setmenu,
    "sort": sort,
    "mBarcode": mBarcode,
    "mDiscount1": mDiscount1,
    "mDiscount2": mDiscount2,
    "mDiscount3": mDiscount3,
    "mPrice4": mPrice4,
    "mDiscount4": mDiscount4,
    "mPrice5": mPrice5,
    "mDiscount5": mDiscount5,
    "mPrice6": mPrice6,
    "mDiscount6": mDiscount6,
    "mQty": mQty,
    "mPCode": mPCode,
  };

  @override
  String toString() {
    return 'ProductExportResult(mCode: $mCode, mRefCode: $mRefCode, mDesc1: $mDesc1, mDesc2: $mDesc2, mUnit: $mUnit, mMeasurement: $mMeasurement, mCategory1: $mCategory1, mCategory2: $mCategory2, mCategory3: $mCategory3, mMaxLevel: $mMaxLevel, mMinLevel: $mMinLevel, mBrand: $mBrand, mColor: $mColor, mSize: $mSize, mAvPrice: $mAvPrice, mAvCost: $mAvCost, mDateCreate: $mDateCreate, mLatPrice: $mLatPrice, mLatCost: $mLatCost, mDateModify: $mDateModify, mModel: $mModel, mSupplierCode: $mSupplierCode, mPicturePath: $mPicturePath, mTradePrice: $mTradePrice, mRetailPrice: $mRetailPrice, mBottomPrice: $mBottomPrice, mMemberPrice: $mMemberPrice, tProductId: $tProductId, mRemarks: $mRemarks, mNonDiscount: $mNonDiscount, mNonStock: $mNonStock, mOriginalPrice: $mOriginalPrice, mBundleSales: $mBundleSales, mTimes: $mTimes, mPrePaid: $mPrePaid, mNonActived: $mNonActived, mStandardCost: $mStandardCost, mExpiryDate: $mExpiryDate, mNonCharge: $mNonCharge, mPrice1: $mPrice1, mPrice2: $mPrice2, mPrice3: $mPrice3, mStockCode: $mStockCode, mSetOption: $mSetOption, mSoldOut: $mSoldOut, mNonWebHide: $mNonWebHide, mWebRemarks: $mWebRemarks, mNewest: $mNewest, mSpecials: $mSpecials, mIsStandPrice: $mIsStandPrice, setmenu: $setmenu, sort: $sort, mBarcode: $mBarcode, mDiscount1: $mDiscount1, mDiscount2: $mDiscount2, mDiscount3: $mDiscount3, mPrice4: $mPrice4, mDiscount4: $mDiscount4, mPrice5: $mPrice5, mDiscount5: $mDiscount5, mPrice6: $mPrice6, mDiscount6: $mDiscount6, mQty: $mQty, mPCode: $mPCode)';
  }
}
