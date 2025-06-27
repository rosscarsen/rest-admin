// To parse this JSON data, do
//
//     final advancedSearchModel = advancedSearchModelFromJson(jsonString);

import 'dart:convert';

import 'category_model.dart';

ProductActionInitModel productActionInitModelFromJson(String str) => ProductActionInitModel.fromJson(json.decode(str));

String productActionInitModelToJson(ProductActionInitModel data) => json.encode(data.toJson());

class ProductActionInitModel {
  int? status;
  String? msg;
  ApiResult? apiResult;

  ProductActionInitModel({this.status, this.msg, this.apiResult});

  factory ProductActionInitModel.fromJson(Map<String, dynamic> json) => ProductActionInitModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ApiResult {
  List<CategoryModel>? category;

  ApiResult({this.category});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    category: json["category"] == null
        ? []
        : List<CategoryModel>.from(json["category"]!.map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x.toJson())),
  };
}
