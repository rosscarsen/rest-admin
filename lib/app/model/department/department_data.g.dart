// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentData _$DepartmentDataFromJson(Map<String, dynamic> json) =>
    DepartmentData(
      mBrand: Functions.asString(json['mBrand']),
      tBrandId: Functions.asString(json['T_Brand_ID']),
      mBrandName: Functions.asString(json['mBrandName']),
    );

Map<String, dynamic> _$DepartmentDataToJson(DepartmentData instance) =>
    <String, dynamic>{
      'mBrand': instance.mBrand,
      'T_Brand_ID': instance.tBrandId,
      'mBrandName': instance.mBrandName,
    };
