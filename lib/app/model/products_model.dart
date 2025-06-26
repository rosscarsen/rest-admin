// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(String str) => ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
  ProductsInfo? productsInfo;
  String? msg;
  int? status;

  ProductsModel({this.productsInfo, this.msg, this.status});

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    productsInfo: json["apiResult"] == null ? null : ProductsInfo.fromJson(json["apiResult"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {"data": productsInfo?.toJson(), "msg": msg, "status": status};

  @override
  String toString() => 'ProductsModel(data: $productsInfo, msg: $msg, status: $status)';
}

class ProductsInfo {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<ProductData>? productData;
  bool? hasMore;

  ProductsInfo({this.total, this.perPage, this.currentPage, this.lastPage, this.productData, this.hasMore});

  factory ProductsInfo.fromJson(Map<String, dynamic> json) => ProductsInfo(
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
  dynamic mPCode;
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
    mPCode: json["mPCode"],
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
}
