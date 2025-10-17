// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final productAddOrEditModel = productAddOrEditModelFromJson(jsonString);

import 'dart:convert';

import '../category/category_model.dart';
import '../unit/unit_data.dart';

ProductAddOrEditModel productAddOrEditModelFromJson(String str) => ProductAddOrEditModel.fromJson(json.decode(str));

String productAddOrEditModelToJson(ProductAddOrEditModel data) => json.encode(data.toJson());

class ProductAddOrEditModel {
  int? status;
  String? msg;
  ProductAddOrEditResult? apiResult;

  ProductAddOrEditModel({this.status, this.msg, this.apiResult});

  factory ProductAddOrEditModel.fromJson(Map<String, dynamic> json) => ProductAddOrEditModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ProductAddOrEditResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ProductAddOrEditResult {
  ProductInfo? productInfo;
  List<CategoryModel>? category;
  List<UnitData>? units;
  List<ProductBarcode>? productBarcode;
  List<ProductSetMeal>? setMeal;
  List<ProductStock>? productStock;
  List<SetMealLimit>? setMealLimit;

  ProductAddOrEditResult({
    this.productInfo,
    this.category,
    this.units,
    this.productBarcode,
    this.setMeal,
    this.productStock,
    this.setMealLimit,
  });

  factory ProductAddOrEditResult.fromJson(Map<String, dynamic> json) => ProductAddOrEditResult(
    productInfo: json["productInfo"] == null ? null : ProductInfo.fromJson(json["productInfo"]),

    category: json["category"] == null
        ? []
        : List<CategoryModel>.from(json["category"]!.map((x) => CategoryModel.fromJson(x))),
    units: json["units"] == null ? [] : List<UnitData>.from(json["units"]!.map((x) => UnitData.fromJson(x))),
    productBarcode: json["barcode"] == null
        ? []
        : List<ProductBarcode>.from(json["barcode"]!.map((x) => ProductBarcode.fromJson(x))),
    setMeal: json["setMeal"] == null
        ? []
        : List<ProductSetMeal>.from(json["setMeal"]!.map((x) => ProductSetMeal.fromJson(x))),
    productStock: json["stock"] == null
        ? []
        : List<ProductStock>.from(json["stock"]!.map((x) => ProductStock.fromJson(x))),
    setMealLimit: json["setMealLimit"] == null
        ? []
        : List<SetMealLimit>.from(json["setMealLimit"]!.map((x) => SetMealLimit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "productInfo": productInfo?.toJson(),
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x.toJson())),
    "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x.toJson())),
    "productBarcode": productBarcode == null ? [] : List<dynamic>.from(productBarcode!.map((x) => x.toJson())),
    "setMeal": setMeal == null ? [] : List<dynamic>.from(setMeal!.map((x) => x.toJson())),
    "stock": productStock == null ? [] : List<dynamic>.from(productStock!.map((x) => x.toJson())),
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
  String? mNonDiscount;
  String? mNonStock;
  dynamic mOriginalPrice;
  String? mBundleSales;
  String? mTimes;
  String? mPrePaid;
  String? mNonActived;
  String? mStandardCost;
  String? mExpiryDate;
  String? mNonCharge;
  String? mPrice;
  String? mPrice1;
  String? mPrice2;
  String? mPrice3;
  String? mStockCode;
  String? mSetOption;
  String? mSoldOut;
  String? mNonWebHide;
  dynamic mWebRemarks;
  String? mNewest;
  String? mSpecials;
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
    mMaxLevel: json["mMax_Level"] ?? "0.00",
    mMinLevel: json["mMin_Level"] ?? "0.00",
    mBrand: json["mBrand"],
    mColor: json["mColor"],
    mSize: json["mSize"],
    mAvPrice: json["mAv_Price"],
    mAvCost: json["mAv_Cost"] ?? "0.00",
    mDateCreate: json["mDate_Create"] == null ? null : DateTime.parse(json["mDate_Create"]),
    mLatPrice: json["mLat_Price"] ?? "0.00",
    mLatCost: json["mLat_Cost"] ?? "0.00",
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
    mNonDiscount: json["mNon_Discount"]?.toString() ?? "0",
    mNonStock: json["mNon_Stock"]?.toString() ?? "1",
    mOriginalPrice: json["mOriginal_Price"],
    mBundleSales: json["mBundle_Sales"]?.toString() ?? "",
    mTimes: json["mTimes"]?.toString() ?? "",
    mPrePaid: json["mPrePaid"]?.toString() ?? "0",
    mNonActived: json["mNonActived"]?.toString() ?? "0",
    mStandardCost: json["mStandard_Cost"] ?? "0.00",
    mExpiryDate: json["mExpiryDate"],
    mNonCharge: json["mNonCharge"]?.toString() ?? "0",
    mPrice: json['mPrice'],
    mPrice1: json["mPrice1"],
    mPrice2: json["mPrice2"],
    mPrice3: json["mPrice3"],
    mStockCode: json["mStockCode"],
    mSetOption: json["mSetOption"]?.toString() ?? "1",
    mSoldOut: json["mSoldOut"]?.toString() ?? "0",
    mNonWebHide: json["mNon_WebHide"]?.toString() ?? "",
    mWebRemarks: json["mWeb_Remarks"],
    mNewest: json["mNewest"]?.toString() ?? "",
    mSpecials: json["mSpecials"]?.toString() ?? "",
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

class ProductBarcode {
  String? mProductCode;
  String? mCode;
  String? mName;
  int? mItem;
  String? mRemarks;
  int? tProductId;
  int? mNonActived;

  ProductBarcode({
    this.mProductCode,
    this.mCode,
    this.mName,
    this.mItem,
    this.mRemarks,
    this.tProductId,
    this.mNonActived,
  });

  factory ProductBarcode.fromJson(Map<String, dynamic> json) => ProductBarcode(
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

class ProductSetMeal {
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
  String? mStep;
  int? mDefault;
  int? mSort;
  int? soldOut;

  ProductSetMeal({
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

  factory ProductSetMeal.fromJson(Map<String, dynamic> json) => ProductSetMeal(
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
    mStep: json["mStep"]?.toString() ?? "",
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

  void copyFrom(ProductSetMeal source) {
    tProductId = source.tProductId;
    mName = source.mName;
    mBarcode = source.mBarcode;
    mPrice = source.mPrice;
    mPrice2 = source.mPrice2;
    mQty = source.mQty;
    mRemarks = source.mRemarks;
    mProductCode = source.mProductCode;
    mId = source.mId;
    mFlag = source.mFlag;
    mTime = source.mTime;
    mPCode = source.mPCode;
    mStep = source.mStep;
    mDefault = source.mDefault;
    mSort = source.mSort;
    soldOut = source.soldOut;
  }

  ProductSetMeal copyWith({
    int? tProductId,
    String? mName,
    String? mBarcode,
    String? mPrice,
    String? mPrice2,
    String? mQty,
    String? mRemarks,
    String? mProductCode,
    int? mId,
    int? mFlag,
    String? mTime,
    String? mPCode,
    String? mStep,
    int? mDefault,
    int? mSort,
    int? soldOut,
  }) {
    return ProductSetMeal(
      tProductId: tProductId ?? this.tProductId,
      mName: mName ?? this.mName,
      mBarcode: mBarcode ?? this.mBarcode,
      mPrice: mPrice ?? this.mPrice,
      mPrice2: mPrice2 ?? this.mPrice2,
      mQty: mQty ?? this.mQty,
      mRemarks: mRemarks ?? this.mRemarks,
      mProductCode: mProductCode ?? this.mProductCode,
      mId: mId ?? this.mId,
      mFlag: mFlag ?? this.mFlag,
      mTime: mTime ?? this.mTime,
      mPCode: mPCode ?? this.mPCode,
      mStep: mStep ?? this.mStep,
      mDefault: mDefault ?? this.mDefault,
      mSort: mSort ?? this.mSort,
      soldOut: soldOut ?? this.soldOut,
    );
  }
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

class ProductStock {
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

  ProductStock({
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

  factory ProductStock.fromJson(Map<String, dynamic> json) => ProductStock(
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
