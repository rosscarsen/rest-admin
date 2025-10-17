import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'unit_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UnitData {
  @JsonKey(name: "mUnit", fromJson: Functions.asString)
  String? mUnit;
  @JsonKey(name: "T_Unit_ID", fromJson: Functions.asString)
  String? tUnitId;

  UnitData({this.mUnit, this.tUnitId});

  UnitData copyWith({String? mUnit, String? tUnitId}) =>
      UnitData(mUnit: mUnit ?? this.mUnit, tUnitId: tUnitId ?? this.tUnitId);

  factory UnitData.fromJson(Map<String, dynamic> json) => _$UnitDataFromJson(json);

  Map<String, dynamic> toJson() => _$UnitDataToJson(this);
}
