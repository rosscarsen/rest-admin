// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

import 'category_model.dart';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  final int? status;
  final String? msg;
  final List<CategoryModel>? apiResult;

  CategoriesModel({this.status, this.msg, this.apiResult});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null
        ? []
        : List<CategoryModel>.from(json["apiResult"]!.map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "apiResult": apiResult == null ? [] : List<dynamic>.from(apiResult!.map((x) => x.toJson())),
  };

  @override
  String toString() => 'CategoriesModel(status: $status, msg: $msg, apiResult: $apiResult)';
}
