// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitEditModel _$UnitEditModelFromJson(Map<String, dynamic> json) =>
    UnitEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : UnitData.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnitEditModelToJson(UnitEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };
