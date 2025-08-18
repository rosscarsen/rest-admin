// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(String str) => ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  ApiResult? apiResult;
  String? msg;
  int? status;

  ProductsModel({this.apiResult, this.msg, this.status});

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {"data": apiResult?.toJson(), "msg": msg, "status": status};

  @override
  String toString() => 'ProductsModel(data: $apiResult, msg: $msg, status: $status)';
}

class ApiResult {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<ProductData>? productData;
  bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.productData, this.hasMore});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    productData: json["data"] == null ? [] : List<ProductData>.from(json["data"]!.map((x) => ProductData.fromJson(x))),
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "data": productData == null ? [] : List<dynamic>.from(productData!.map((x) => x.toJson())),
    "has_more": hasMore,
  };

  @override
  String toString() {
    return 'ProductsInfo(total: $total, perPage: $perPage, currentPage: $currentPage, lastPage: $lastPage, data: $productData, hasMore: $hasMore)';
  }
}

class ProductData {
  int? sort;
  int? tProductId;
  String? mCode;
  String? mDesc1;
  String? mCategory1;
  String? mCategory2;
  String? mDesc2;
  String? mRemarks;
  String? mUnit;
  String? mMeasurement;
  String? mModel;
  String? mColor;
  String? mSize;
  String? mPrice;
  String? mDiscount;
  String? mQty;
  String? mPCode;
  int? mSoldOut;
  String? imagesPath;

  ProductData({
    this.sort,
    this.tProductId,
    this.mCode,
    this.mDesc1,
    this.mCategory1,
    this.mCategory2,
    this.mDesc2,
    this.mRemarks,
    this.mUnit,
    this.mMeasurement,
    this.mModel,
    this.mColor,
    this.mSize,
    this.mPrice,
    this.mDiscount,
    this.mQty,
    this.mPCode,
    this.mSoldOut,
    this.imagesPath,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    sort: json["sort"],
    tProductId: json["T_Product_ID"],
    mCode: json["mCode"],
    mDesc1: json["mDesc1"],
    mCategory1: json["mCategory1"],
    mCategory2: json["mCategory2"],
    mDesc2: json["mDesc2"],
    mRemarks: json["mRemarks"],
    mUnit: json["mUnit"],
    mMeasurement: json["mMeasurement"],
    mModel: json["mModel"],
    mColor: json["mColor"],
    mSize: json["mSize"],
    mPrice: json["mPrice"],
    mDiscount: json["mDiscount"],
    mQty: json["mQty"],
    mPCode: json["mPCode"]?.toString() ?? "",
    mSoldOut: json["mSoldOut"],
    imagesPath: json["imagesPath"],
  );

  Map<String, dynamic> toJson() => {
    "sort": sort,
    "T_Product_ID": tProductId,
    "mCode": mCode,
    "mDesc1": mDesc1,
    "mCategory1": mCategory1,
    "mCategory2": mCategory2,
    "mDesc2": mDesc2,
    "mRemarks": mRemarks,
    "mUnit": mUnit,
    "mMeasurement": mMeasurement,
    "mModel": mModel,
    "mColor": mColor,
    "mSize": mSize,
    "mPrice": mPrice,
    "mDiscount": mDiscount,
    "mQty": mQty,
    "mPCode": mPCode,
    "mSoldOut": mSoldOut,
    "imagesPath": imagesPath,
  };

  @override
  String toString() {
    return 'ProductData(sort: $sort, tProductId: $tProductId, mCode: $mCode, mDesc1: $mDesc1, mCategory1: $mCategory1, mCategory2: $mCategory2, mDesc2: $mDesc2, mRemarks: $mRemarks, mUnit: $mUnit, mMeasurement: $mMeasurement, mModel: $mModel, mColor: $mColor, mSize: $mSize, mPrice: $mPrice, mDiscount: $mDiscount, mQty: $mQty, mPCode: $mPCode, mSoldOut: $mSoldOut, imagesPath: $imagesPath)';
  }

  void copyForm(ProductData source) {
    sort = source.sort;
    tProductId = source.tProductId;
    mCode = source.mCode;
    mDesc1 = source.mDesc1;
    mCategory1 = source.mCategory1;
    mCategory2 = source.mCategory2;
    mDesc2 = source.mDesc2;
    mRemarks = source.mRemarks;
    mUnit = source.mUnit;
    mMeasurement = source.mMeasurement;
    mModel = source.mModel;
    mColor = source.mColor;
    mSize = source.mSize;
    mPrice = source.mPrice;
    mDiscount = source.mDiscount;
    mQty = source.mQty;
    mPCode = source.mPCode;
    mSoldOut = source.mSoldOut;
    imagesPath = source.imagesPath;
  }

  ProductData copyWith({
    int? sort,
    int? tProductId,
    String? mCode,
    String? mDesc1,
    String? mCategory1,
    String? mCategory2,
    String? mDesc2,
    String? mRemarks,
    String? mUnit,
    String? mMeasurement,
    String? mModel,
    String? mColor,
    String? mSize,
    String? mPrice,
    String? mDiscount,
    String? mQty,
    String? mPCode,
    int? mSoldOut,
    String? imagesPath,
  }) {
    return ProductData(
      sort: sort ?? this.sort,
      tProductId: tProductId ?? this.tProductId,
      mCode: mCode ?? this.mCode,
      mDesc1: mDesc1 ?? this.mDesc1,
      mCategory1: mCategory1 ?? this.mCategory1,
      mCategory2: mCategory2 ?? this.mCategory2,
      mDesc2: mDesc2 ?? this.mDesc2,
      mRemarks: mRemarks ?? this.mRemarks,
      mUnit: mUnit ?? this.mUnit,
      mMeasurement: mMeasurement ?? this.mMeasurement,
      mModel: mModel ?? this.mModel,
      mColor: mColor ?? this.mColor,
      mSize: mSize ?? this.mSize,
      mPrice: mPrice ?? this.mPrice,
      mDiscount: mDiscount ?? this.mDiscount,
      mQty: mQty ?? this.mQty,
      mPCode: mPCode ?? this.mPCode,
      mSoldOut: mSoldOut ?? this.mSoldOut,
      imagesPath: imagesPath ?? this.imagesPath,
    );
  }
}
