// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyEditModel _$CurrencyEditModelFromJson(Map<String, dynamic> json) =>
    CurrencyEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : CurrencyData.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrencyEditModelToJson(CurrencyEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };
