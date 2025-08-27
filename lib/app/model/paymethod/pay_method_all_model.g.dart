// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_method_all_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayMethodAllModel _$PayMethodAllModelFromJson(Map<String, dynamic> json) =>
    PayMethodAllModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: (json['apiResult'] as List<dynamic>?)
          ?.map((e) => PayMethodData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PayMethodAllModelToJson(PayMethodAllModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };
