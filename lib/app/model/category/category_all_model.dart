// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final categoryAllModel = categoryAllModelFromJson(jsonString);

import 'dart:convert';

import 'category_model.dart';

CategoryAllModel categoryAllModelFromJson(String str) => CategoryAllModel.fromJson(json.decode(str));

String categoryAllModelToJson(CategoryAllModel data) => json.encode(data.toJson());

class CategoryAllModel {
  final int? status;
  final String? msg;
  final List<CategoryModel>? apiResult;

  CategoryAllModel({this.status, this.msg, this.apiResult});

  factory CategoryAllModel.fromJson(Map<String, dynamic> json) => CategoryAllModel(
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
  String toString() => 'CategoryAllModel(status: $status, msg: $msg, apiResult: $apiResult)';
}
