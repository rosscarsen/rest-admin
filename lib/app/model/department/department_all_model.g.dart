// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_all_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentAllModel _$DepartmentAllModelFromJson(Map<String, dynamic> json) =>
    DepartmentAllModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: (json['apiResult'] as List<dynamic>?)
          ?.map((e) => DepartmentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentAllModelToJson(DepartmentAllModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };
