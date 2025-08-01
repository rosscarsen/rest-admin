// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final setMealModel = setMealModelFromJson(jsonString);

import 'dart:convert';

SetMealModel setMealModelFromJson(String str) => SetMealModel.fromJson(json.decode(str));

String setMealModelToJson(SetMealModel data) => json.encode(data.toJson());

class SetMealModel {
  final int? status;
  final String? msg;
  final ApiResult? apiResult;

  SetMealModel({this.status, this.msg, this.apiResult});

  factory SetMealModel.fromJson(Map<String, dynamic> json) => SetMealModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};

  @override
  String toString() => 'SetMealModel(status: $status, msg: $msg, apiResult: $apiResult)';
}

class ApiResult {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final List<SetMealData>? data;
  final bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: json["data"] == null ? [] : List<SetMealData>.from(json["data"]!.map((x) => SetMealData.fromJson(x))),
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

  @override
  String toString() {
    return 'ApiResult(total: $total, perPage: $perPage, currentPage: $currentPage, lastPage: $lastPage, data: $data, hasMore: $hasMore)';
  }
}

class SetMealData {
  final int? tSetmenuId;
  final String? mCode;
  final String? mDesc;
  final DateTime? mDateCreate;
  final DateTime? mDateModify;
  final String? detail;

  SetMealData({this.tSetmenuId, this.mCode, this.mDesc, this.mDateCreate, this.mDateModify, this.detail});

  factory SetMealData.fromJson(Map<String, dynamic> json) => SetMealData(
    tSetmenuId: json["T_setmenu_ID"],
    mCode: json["mCode"],
    mDesc: json["mDesc"],
    mDateCreate: json["mDate_Create"] == null ? null : DateTime.parse(json["mDate_Create"]),
    mDateModify: json["mDate_Modify"] == null ? null : DateTime.parse(json["mDate_Modify"]),
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "T_setmenu_ID": tSetmenuId,
    "mCode": mCode,
    "mDesc": mDesc,
    "mDate_Create": mDateCreate?.toIso8601String(),
    "mDate_Modify": mDateModify?.toIso8601String(),
    "detail": detail,
  };
}
