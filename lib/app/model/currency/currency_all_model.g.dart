// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_all_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyAllModel _$CurrencyAllModelFromJson(Map<String, dynamic> json) =>
    CurrencyAllModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: (json['apiResult'] as List<dynamic>?)
          ?.map((e) => CurrencyData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrencyAllModelToJson(CurrencyAllModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };
