// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentEditModel _$DepartmentEditModelFromJson(Map<String, dynamic> json) =>
    DepartmentEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : DepartmentData.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentEditModelToJson(
  DepartmentEditModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.apiResult,
};
