// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final departmentModel = departmentModelFromJson(jsonString);

import 'dart:convert';

List<DepartmentModel> departmentModelFromJson(String str) =>
    List<DepartmentModel>.from(json.decode(str).map((x) => DepartmentModel.fromJson(x)));

String departmentModelToJson(List<DepartmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepartmentModel {
  String? mBrand;
  int? tBrandId;
  dynamic mBrandName;

  DepartmentModel({this.mBrand, this.tBrandId, this.mBrandName});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(mBrand: json["mBrand"], tBrandId: json["T_Brand_ID"], mBrandName: json["mBrandName"]);

  Map<String, dynamic> toJson() => {"mBrand": mBrand, "T_Brand_ID": tBrandId, "mBrandName": mBrandName};

  @override
  String toString() => 'DepartmentModel(mBrand: $mBrand, tBrandId: $tBrandId, mBrandName: $mBrandName)';
}
