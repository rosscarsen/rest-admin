import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'set_meal_data.g.dart';

@JsonSerializable(explicitToJson: true)
class SetMealData {
  @JsonKey(name: "T_setmenu_ID", fromJson: Functions.asString)
  String? tSetmenuId;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "mDesc", fromJson: Functions.asString)
  String? mDesc;
  @JsonKey(name: "mDate_Create", fromJson: Functions.asString)
  String? mDateCreate;
  @JsonKey(name: "mDate_Modify", fromJson: Functions.asString)
  String? mDateModify;
  @JsonKey(name: "detail", fromJson: Functions.asString)
  String? detail;

  SetMealData({this.tSetmenuId, this.mCode, this.mDesc, this.mDateCreate, this.mDateModify, this.detail});

  SetMealData copyWith({
    String? tSetmenuId,
    String? mCode,
    String? mDesc,
    String? mDateCreate,
    String? mDateModify,
    String? detail,
  }) => SetMealData(
    tSetmenuId: tSetmenuId ?? this.tSetmenuId,
    mCode: mCode ?? this.mCode,
    mDesc: mDesc ?? this.mDesc,
    mDateCreate: mDateCreate ?? this.mDateCreate,
    mDateModify: mDateModify ?? this.mDateModify,
    detail: detail ?? this.detail,
  );

  factory SetMealData.fromJson(Map<String, dynamic> json) => _$SetMealDataFromJson(json);

  Map<String, dynamic> toJson() => _$SetMealDataToJson(this);
}
