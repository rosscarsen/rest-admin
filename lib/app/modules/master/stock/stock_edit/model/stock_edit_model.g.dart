// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockEditModel _$StockEditModelFromJson(Map<String, dynamic> json) =>
    StockEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : StockData.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockEditModelToJson(StockEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult?.toJson(),
    };
