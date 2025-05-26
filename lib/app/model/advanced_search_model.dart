// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final advancedSearchModel = advancedSearchModelFromJson(jsonString);

import 'dart:convert';

import 'category_model.dart';
import 'department_model.dart';

AdvancedSearchModel advancedSearchModelFromJson(String str) => AdvancedSearchModel.fromJson(json.decode(str));

String advancedSearchModelToJson(AdvancedSearchModel data) => json.encode(data.toJson());

class AdvancedSearchModel {
  List<CategoryModel>? category;
  List<DepartmentModel>? department;

  AdvancedSearchModel({this.category, this.department});

  factory AdvancedSearchModel.fromJson(Map<String, dynamic> json) => AdvancedSearchModel(
    category:
        json["category"] == null
            ? []
            : List<CategoryModel>.from(json["category"]!.map((x) => CategoryModel.fromJson(x))),
    department:
        json["department"] == null
            ? []
            : List<DepartmentModel>.from(json["department"]!.map((x) => DepartmentModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x.toJson())),
    "department": department == null ? [] : List<dynamic>.from(department!.map((x) => x.toJson())),
  };

  @override
  String toString() => 'AdvancedSearchModel(category: $category, department: $department)';
}
