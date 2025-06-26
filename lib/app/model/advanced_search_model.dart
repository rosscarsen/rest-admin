// To parse this JSON data, do
//
//     final advancedSearchModel = advancedSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:rest_admin/app/model/category_model.dart';
import 'package:rest_admin/app/model/department_model.dart';

AdvancedSearchModel advancedSearchModelFromJson(String str) => AdvancedSearchModel.fromJson(json.decode(str));

String advancedSearchModelToJson(AdvancedSearchModel data) => json.encode(data.toJson());

class AdvancedSearchModel {
  int? status;
  String? msg;
  ApiResult? apiResult;

  AdvancedSearchModel({this.status, this.msg, this.apiResult});

  factory AdvancedSearchModel.fromJson(Map<String, dynamic> json) => AdvancedSearchModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ApiResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ApiResult {
  List<CategoryModel>? category;
  List<DepartmentModel>? department;

  ApiResult({this.category, this.department});

  factory ApiResult.fromJson(Map<String, dynamic> json) => ApiResult(
    category: json["category"] == null
        ? []
        : List<CategoryModel>.from(json["category"]!.map((x) => CategoryModel.fromJson(x))),
    department: json["department"] == null
        ? []
        : List<DepartmentModel>.from(json["department"]!.map((x) => DepartmentModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x.toJson())),
    "department": department == null ? [] : List<dynamic>.from(department!.map((x) => x.toJson())),
  };
}
