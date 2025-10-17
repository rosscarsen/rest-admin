// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_meal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMealData _$SetMealDataFromJson(Map<String, dynamic> json) => SetMealData(
  tSetmenuId: Functions.asString(json['T_setmenu_ID']),
  mCode: Functions.asString(json['mCode']),
  mDesc: Functions.asString(json['mDesc']),
  mDateCreate: Functions.asString(json['mDate_Create']),
  mDateModify: Functions.asString(json['mDate_Modify']),
  detail: Functions.asString(json['detail']),
);

Map<String, dynamic> _$SetMealDataToJson(SetMealData instance) =>
    <String, dynamic>{
      'T_setmenu_ID': instance.tSetmenuId,
      'mCode': instance.mCode,
      'mDesc': instance.mDesc,
      'mDate_Create': instance.mDateCreate,
      'mDate_Modify': instance.mDateModify,
      'detail': instance.detail,
    };
