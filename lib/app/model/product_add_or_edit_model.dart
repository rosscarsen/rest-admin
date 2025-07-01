// To parse this JSON data, do
//
//     final productAddOrEditModel = productAddOrEditModelFromJson(jsonString);

import 'dart:convert';

import 'category_model.dart';
import 'unit_model.dart';

ProductAddOrEditModel productAddOrEditModelFromJson(String str) => ProductAddOrEditModel.fromJson(json.decode(str));

String productAddOrEditModelToJson(ProductAddOrEditModel data) => json.encode(data.toJson());

class ProductAddOrEditModel {
  int? status;
  String? msg;
  ApiResult? apiResult;

  ProductAddOrEditModel({this.status, this.msg, this.apiResult});

  factory ProductAddOrEditModel.fromJson(Map<String, dynamic> json) => ProductAddOrEditModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ApiResult {
  ProductInfo? productInfo;
  List<CategoryModel>? category;
  List<UnitModel>? units;
  List<Barcode>? barcode;
  List<SetMeal>? setMeal;
  List<Stock>? stock;
  List<SetMealLimit>? setMealLimit;

  ApiResult({this.productInfo, this.category, this.units, this.barcode, this.setMeal, this.stock, this.setMealLimit});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    productInfo: json["productInfo"] == null ? null : ProductInfo.fromJson(json["productInfo"]),

    category: json["category"] == null
        ? []
        : List<CategoryModel>.from(json["category"]!.map((x) => CategoryModel.fromJson(x))),
    units: json["units"] == null ? [] : List<UnitModel>.from(json["units"]!.map((x) => UnitModel.fromJson(x))),
    barcode: json["barcode"] == null ? [] : List<Barcode>.from(json["barcode"]!.map((x) => Barcode.fromJson(x))),
    setMeal: json["setMeal"] == null ? [] : List<SetMeal>.from(json["setMeal"]!.map((x) => SetMeal.fromJson(x))),
    stock: json["stock"] == null ? [] : List<Stock>.from(json["stock"]!.map((x) => Stock.fromJson(x))),
    setMealLimit: json["setMealLimit"] == null
        ? []
        : List<SetMealLimit>.from(json["setMealLimit"]!.map((x) => SetMealLimit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "productInfo": productInfo?.toJson(),
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x.toJson())),
    "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x.toJson())),
    "barcode": barcode == null ? [] : List<dynamic>.from(barcode!.map((x) => x.toJson())),
    "setMeal": setMeal == null ? [] : List<dynamic>.from(setMeal!.map((x) => x.toJson())),
    "stock": stock == null ? [] : List<dynamic>.from(stock!.map((x) => x.toJson())),
    "setMealLimit": setMealLimit == null ? [] : List<dynamic>.from(setMealLimit!.map((x) => x.toJson())),
  };
}

class ProductInfo {
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
  dynamic mColor;
  dynamic mSize;
  String? mAvPrice;
  String? mAvCost;
  DateTime? mDateCreate;
  String? mLatPrice;
  String? mLatCost;
  DateTime? mDateModify;
  String? mModel;
  String? mSupplierCode;
  String? mPicturePath;
  dynamic mTradePrice;
  dynamic mRetailPrice;
  String? mBottomPrice;
  dynamic mMemberPrice;
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
  String? mPrice;
  String? mPrice1;
  String? mPrice2;
  String? mPrice3;
  String? mStockCode;
  int? mSetOption;
  int? mSoldOut;
  int? mNonWebHide;
  dynamic mWebRemarks;
  int? mNewest;
  int? mSpecials;
  dynamic mIsStandPrice;
  String? setmenu;

  ProductInfo({
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
    this.mPrice,
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
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
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
    mPrice: json['mPrice'],
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
    "mPrice": mPrice,
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
  };
}

class Barcode {
  String? mProductCode;
  String? mCode;
  String? mName;
  int? mItem;
  String? mRemarks;
  int? tProductId;
  int? mNonActived;

  Barcode({this.mProductCode, this.mCode, this.mName, this.mItem, this.mRemarks, this.tProductId, this.mNonActived});

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
    mProductCode: json["mProduct_Code"],
    mCode: json["mCode"],
    mName: json["mName"],
    mItem: json["mItem"],
    mRemarks: json["mRemarks"],
    tProductId: json["T_Product_ID"],
    mNonActived: json["mNonActived"],
  );

  Map<String, dynamic> toJson() => {
    "mProduct_Code": mProductCode,
    "mCode": mCode,
    "mName": mName,
    "mItem": mItem,
    "mRemarks": mRemarks,
    "T_Product_ID": tProductId,
    "mNonActived": mNonActived,
  };
}

class SetMeal {
  int? tProductId;
  String? mName;
  String? mBarcode;
  String? mPrice;
  String? mPrice2;
  String? mQty;
  String? mRemarks;
  String? mProductCode;
  int? mId;
  int? mFlag;
  String? mTime;
  String? mPCode;
  int? mStep;
  int? mDefault;
  int? mSort;
  int? soldOut;

  SetMeal({
    this.tProductId,
    this.mName,
    this.mBarcode,
    this.mPrice,
    this.mPrice2,
    this.mQty,
    this.mRemarks,
    this.mProductCode,
    this.mId,
    this.mFlag,
    this.mTime,
    this.mPCode,
    this.mStep,
    this.mDefault,
    this.mSort,
    this.soldOut,
  });

  factory SetMeal.fromJson(Map<String, dynamic> json) => SetMeal(
    tProductId: json["T_Product_ID"],
    mName: json["mName"],
    mBarcode: json["mBarcode"],
    mPrice: json["mPrice"],
    mPrice2: json["mPrice2"],
    mQty: json["mQty"],
    mRemarks: json["mRemarks"],
    mProductCode: json["mProduct_Code"],
    mId: json["mID"],
    mFlag: json["mFlag"],
    mTime: json["mTime"],
    mPCode: json["mPCode"],
    mStep: json["mStep"],
    mDefault: json["mDefault"],
    mSort: json["mSort"],
    soldOut: json["Sold_out"],
  );

  Map<String, dynamic> toJson() => {
    "T_Product_ID": tProductId,
    "mName": mName,
    "mBarcode": mBarcode,
    "mPrice": mPrice,
    "mPrice2": mPrice2,
    "mQty": mQty,
    "mRemarks": mRemarks,
    "mProduct_Code": mProductCode,
    "mID": mId,
    "mFlag": mFlag,
    "mTime": mTime,
    "mPCode": mPCode,
    "mStep": mStep,
    "mDefault": mDefault,
    "mSort": mSort,
    "Sold_out": soldOut,
  };
}

class SetMealLimit {
  int? setLimitId;
  int? tProductId;
  int? mStep;
  int? limitMax;
  int? obligatory;
  String? zhtw;
  String? enus;

  SetMealLimit({this.setLimitId, this.tProductId, this.mStep, this.limitMax, this.obligatory, this.zhtw, this.enus});

  factory SetMealLimit.fromJson(Map<String, dynamic> json) => SetMealLimit(
    setLimitId: json["set_limit_id"],
    tProductId: json["t_product_id"],
    mStep: json["mStep"],
    limitMax: json["limit_max"],
    obligatory: json["obligatory"],
    zhtw: json["zhtw"],
    enus: json["enus"],
  );

  Map<String, dynamic> toJson() => {
    "set_limit_id": setLimitId,
    "t_product_id": tProductId,
    "mStep": mStep,
    "limit_max": limitMax,
    "obligatory": obligatory,
    "zhtw": zhtw,
    "enus": enus,
  };
}

class Stock {
  String? mPhone;
  String? mName;
  String? mAddress;
  String? mAttn;
  String? mFax;
  String? mZip;
  String? mEmail;
  String? mRemarks;
  String? mCode;
  int? tStockId;
  String? mSalesMemoFooter;
  String? mSalesMemoRemarks;
  int? mNonActive;
  String? mFloorplanPreFix;
  int? mRefNo;
  int? mKitchenLabel;
  String? mOpenning;
  String? mQty;

  Stock({
    this.mPhone,
    this.mName,
    this.mAddress,
    this.mAttn,
    this.mFax,
    this.mZip,
    this.mEmail,
    this.mRemarks,
    this.mCode,
    this.tStockId,
    this.mSalesMemoFooter,
    this.mSalesMemoRemarks,
    this.mNonActive,
    this.mFloorplanPreFix,
    this.mRefNo,
    this.mKitchenLabel,
    this.mOpenning,
    this.mQty,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    mPhone: json["mPhone"],
    mName: json["mName"],
    mAddress: json["mAddress"],
    mAttn: json["mAttn"],
    mFax: json["mFax"],
    mZip: json["mZip"],
    mEmail: json["mEmail"],
    mRemarks: json["mRemarks"],
    mCode: json["mCode"],
    tStockId: json["T_Stock_ID"],
    mSalesMemoFooter: json["mSalesMemo_Footer"],
    mSalesMemoRemarks: json["mSalesMemo_Remarks"],
    mNonActive: json["mNon_Active"],
    mFloorplanPreFix: json["mFloorplan_PreFix"],
    mRefNo: json["mRefNo"],
    mKitchenLabel: json["mKitchenLabel"],
    mOpenning: json["mOpenning"],
    mQty: json["mQty"],
  );

  Map<String, dynamic> toJson() => {
    "mPhone": mPhone,
    "mName": mName,
    "mAddress": mAddress,
    "mAttn": mAttn,
    "mFax": mFax,
    "mZip": mZip,
    "mEmail": mEmail,
    "mRemarks": mRemarks,
    "mCode": mCode,
    "T_Stock_ID": tStockId,
    "mSalesMemo_Footer": mSalesMemoFooter,
    "mSalesMemo_Remarks": mSalesMemoRemarks,
    "mNon_Active": mNonActive,
    "mFloorplan_PreFix": mFloorplanPreFix,
    "mRefNo": mRefNo,
    "mKitchenLabel": mKitchenLabel,
    "mOpenning": mOpenning,
    "mQty": mQty,
  };
}
