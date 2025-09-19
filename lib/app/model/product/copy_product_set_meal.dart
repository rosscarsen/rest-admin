// To parse this JSON data, do
//
//     final copyProductSetMealModel = copyProductSetMealModelFromJson(jsonString);

import 'dart:convert';

CopyProductSetMealModel copyProductSetMealModelFromJson(String str) =>
    CopyProductSetMealModel.fromJson(json.decode(str));

String copyProductSetMealModelToJson(CopyProductSetMealModel data) => json.encode(data.toJson());

class CopyProductSetMealModel {
  /// 复制食品套餐
  final int? status;
  final String? msg;
  final CopyProductSetMealResult? apiResult;

  CopyProductSetMealModel({this.status, this.msg, this.apiResult});

  CopyProductSetMealModel copyWith({int? status, String? msg, CopyProductSetMealResult? apiResult}) =>
      CopyProductSetMealModel(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        apiResult: apiResult ?? this.apiResult,
      );

  factory CopyProductSetMealModel.fromJson(Map<String, dynamic> json) => CopyProductSetMealModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : CopyProductSetMealResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class CopyProductSetMealResult {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final List<ProductSetMealData>? data;
  final bool? hasMore;

  CopyProductSetMealResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  CopyProductSetMealResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<ProductSetMealData>? data,
    bool? hasMore,
  }) => CopyProductSetMealResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory CopyProductSetMealResult.fromJson(Map<String, dynamic> json) => CopyProductSetMealResult(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: json["data"] == null
        ? []
        : List<ProductSetMealData>.from(json["data"]!.map((x) => ProductSetMealData.fromJson(x))),
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

class ProductSetMealData {
  final int? tProductId;
  final String? mCode;
  final String? mDesc1;
  final String? mCategory1;
  final String? mCategory2;
  final String? mDesc2;
  final String? mRemarks;
  final String? mUnit;
  final String? mMeasurement;
  final String? mPCode;

  ProductSetMealData({
    this.tProductId,
    this.mCode,
    this.mDesc1,
    this.mCategory1,
    this.mCategory2,
    this.mDesc2,
    this.mRemarks,
    this.mUnit,
    this.mMeasurement,
    this.mPCode,
  });

  ProductSetMealData copyWith({
    int? tProductId,
    String? mCode,
    String? mDesc1,
    String? mCategory1,
    String? mCategory2,
    String? mDesc2,
    String? mRemarks,
    String? mUnit,
    String? mMeasurement,
    String? mPCode,
  }) => ProductSetMealData(
    tProductId: tProductId ?? this.tProductId,
    mCode: mCode ?? this.mCode,
    mDesc1: mDesc1 ?? this.mDesc1,
    mCategory1: mCategory1 ?? this.mCategory1,
    mCategory2: mCategory2 ?? this.mCategory2,
    mDesc2: mDesc2 ?? this.mDesc2,
    mRemarks: mRemarks ?? this.mRemarks,
    mUnit: mUnit ?? this.mUnit,
    mMeasurement: mMeasurement ?? this.mMeasurement,
    mPCode: mPCode ?? this.mPCode,
  );

  factory ProductSetMealData.fromJson(Map<String, dynamic> json) => ProductSetMealData(
    tProductId: json["T_Product_ID"],
    mCode: json["mCode"],
    mDesc1: json["mDesc1"],
    mCategory1: json["mCategory1"],
    mCategory2: json["mCategory2"],
    mDesc2: json["mDesc2"],
    mRemarks: json["mRemarks"],
    mUnit: json["mUnit"],
    mMeasurement: json["mMeasurement"],
    mPCode: json["mPCode"],
  );

  Map<String, dynamic> toJson() => {
    "T_Product_ID": tProductId,
    "mCode": mCode,
    "mDesc1": mDesc1,
    "mCategory1": mCategory1,
    "mCategory2": mCategory2,
    "mDesc2": mDesc2,
    "mRemarks": mRemarks,
    "mUnit": mUnit,
    "mMeasurement": mMeasurement,
    "mPCode": mPCode,
  };
}
