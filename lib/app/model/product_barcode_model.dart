// To parse this JSON data, do
//
//     final productBarcodeModel = productBarcodeModelFromJson(jsonString);

import 'dart:convert';

ProductBarcodeModel productBarcodeModelFromJson(String str) => ProductBarcodeModel.fromJson(json.decode(str));

String productBarcodeModelToJson(ProductBarcodeModel data) => json.encode(data.toJson());

class ProductBarcodeModel {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<ProductBarcodeData>? data;
  bool? hasMore;

  ProductBarcodeModel({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  factory ProductBarcodeModel.fromJson(Map<String, dynamic> json) => ProductBarcodeModel(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data:
        json["data"] == null
            ? []
            : List<ProductBarcodeData>.from(json["data"]!.map((x) => ProductBarcodeData.fromJson(x))),
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "has_more": hasMore,
  };
}

class ProductBarcodeData {
  String? mProductCode;
  String? mCode;
  String? mName;
  int? mItem;
  String? mRemarks;
  int? tProductId;
  int? mNonActived;

  ProductBarcodeData({
    this.mProductCode,
    this.mCode,
    this.mName,
    this.mItem,
    this.mRemarks,
    this.tProductId,
    this.mNonActived,
  });

  factory ProductBarcodeData.fromJson(Map<String, dynamic> json) => ProductBarcodeData(
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
