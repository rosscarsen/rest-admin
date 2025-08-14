// To parse this JSON data, do
//
//     final masterCategoryModel = masterCategoryModelFromJson(jsonString);

import 'dart:convert';

import '../../../model/category_model.dart';

MasterCategoryModel masterCategoryModelFromJson(String str) => MasterCategoryModel.fromJson(json.decode(str));

String masterCategoryModelToJson(MasterCategoryModel data) => json.encode(data.toJson());

class MasterCategoryModel {
  final int? status;
  final String? msg;
  final ApiResult? apiResult;

  MasterCategoryModel({this.status, this.msg, this.apiResult});

  MasterCategoryModel copyWith({int? status, String? msg, ApiResult? apiResult}) =>
      MasterCategoryModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory MasterCategoryModel.fromJson(Map<String, dynamic> json) => MasterCategoryModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ApiResult {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final List<CategoryModel>? data;
  final bool? hasMore;

  ApiResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  ApiResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<CategoryModel>? data,
    bool? hasMore,
  }) => ApiResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: json["data"] == null ? [] : List<CategoryModel>.from(json["data"]!.map((x) => CategoryModel.fromJson(x))),
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
