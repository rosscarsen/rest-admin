// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_all_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterAllModel _$PrinterAllModelFromJson(Map<String, dynamic> json) =>
    PrinterAllModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: (json['apiResult'] as List<dynamic>?)
          ?.map((e) => PrinterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrinterAllModelToJson(PrinterAllModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };
