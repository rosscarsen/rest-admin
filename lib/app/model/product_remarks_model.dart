// To parse this JSON data, do
//
//     final productRemarksModel = productRemarksModelFromJson(jsonString);

import 'dart:convert';

ProductRemarksModel productRemarksModelFromJson(String str) => ProductRemarksModel.fromJson(json.decode(str));

String productRemarksModelToJson(ProductRemarksModel data) => json.encode(data.toJson());

class ProductRemarksModel {
  int? status;
  String? msg;
  ApiResult? apiResult;

  ProductRemarksModel({this.status, this.msg, this.apiResult});

  factory ProductRemarksModel.fromJson(Map<String, dynamic> json) => ProductRemarksModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ApiResult {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<ProductRemarksInfo>? productRemarksInfo;
  bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.productRemarksInfo, this.hasMore});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    productRemarksInfo: json["data"] == null
        ? []
        : List<ProductRemarksInfo>.from(json["data"]!.map((x) => ProductRemarksInfo.fromJson(x))),
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
    "data": productRemarksInfo == null ? [] : List<dynamic>.from(productRemarksInfo!.map((x) => x.toJson())),
    "has_more": hasMore,
  };
}

class ProductRemarksInfo {
  int? mId;
  String? mRemark;
  int? mType;
  int? mSort;
  int? mVisible;
  List<RemarksDetail>? remarksDetails;

  ProductRemarksInfo({this.mId, this.mRemark, this.mType, this.mSort, this.mVisible, this.remarksDetails});

  factory ProductRemarksInfo.fromJson(Map<String, dynamic> json) => ProductRemarksInfo(
    mId: json["m_id"],
    mRemark: json["m_remark"],
    mType: json["mType"],
    mSort: json["mSort"],
    mVisible: json["mVisible"],
    remarksDetails: json["remarksDetails"] == null
        ? []
        : List<RemarksDetail>.from(json["remarksDetails"]!.map((x) => RemarksDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "m_id": mId,
    "m_remark": mRemark,
    "mType": mType,
    "mSort": mSort,
    "mVisible": mVisible,
    "remarksDetails": remarksDetails == null ? [] : List<dynamic>.from(remarksDetails!.map((x) => x.toJson())),
  };
}

class RemarksDetail {
  int? mId;
  String? mDetail;
  String? mPrice;
  String? mRemark;
  int? tId;
  int? mOverwrite;
  dynamic mSort;
  int? mRemarkType;
  int? mSoldOut;
  int? mType;

  RemarksDetail({
    this.mId,
    this.mDetail,
    this.mPrice,
    this.mRemark,
    this.tId,
    this.mOverwrite,
    this.mSort,
    this.mRemarkType,
    this.mSoldOut,
    this.mType,
  });

  factory RemarksDetail.fromJson(Map<String, dynamic> json) => RemarksDetail(
    mId: json["m_id"],
    mDetail: json["m_detail"],
    mPrice: json["m_price"],
    mRemark: json["m_remark"],
    tId: json["t_id"],
    mOverwrite: json["mOverwrite"],
    mSort: json["mSort"],
    mRemarkType: json["mRemark_Type"],
    mSoldOut: json["mSoldOut"],
    mType: json["m_type"],
  );

  Map<String, dynamic> toJson() => {
    "m_id": mId,
    "m_detail": mDetail,
    "m_price": mPrice,
    "m_remark": mRemark,
    "t_id": tId,
    "mOverwrite": mOverwrite,
    "mSort": mSort,
    "mRemark_Type": mRemarkType,
    "mSoldOut": mSoldOut,
    "m_type": mType,
  };
}
