// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final unitModel = unitModelFromJson(jsonString);

import 'dart:convert';

List<UnitModel> unitModelFromJson(String str) =>
    List<UnitModel>.from(json.decode(str).map((x) => UnitModel.fromJson(x)));

String unitModelToJson(List<UnitModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnitModel {
  String? mUnit;
  int? tUnitId;

  UnitModel({this.mUnit, this.tUnitId});

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(mUnit: json["mUnit"], tUnitId: json["T_Unit_ID"]);

  Map<String, dynamic> toJson() => {"mUnit": mUnit, "T_Unit_ID": tUnitId};

  @override
  String toString() => 'UnitModel(mUnit: $mUnit, tUnitId: $tUnitId)';
}
