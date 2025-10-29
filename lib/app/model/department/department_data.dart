import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'department_data.g.dart';

@JsonSerializable(explicitToJson: true)
class DepartmentData {
  @JsonKey(name: "mBrand", fromJson: Functions.asString)
  String? mBrand;
  @JsonKey(name: "T_Brand_ID", fromJson: Functions.asString)
  String? tBrandId;
  @JsonKey(name: "mBrandName", fromJson: Functions.asString)
  String? mBrandName;

  DepartmentData({this.mBrand, this.tBrandId, this.mBrandName});

  factory DepartmentData.fromJson(Map<String, dynamic> json) => _$DepartmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentDataToJson(this);
}
