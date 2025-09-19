// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterPageModel _$PrinterPageModelFromJson(Map<String, dynamic> json) => PrinterPageModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  apiResult: json['apiResult'] == null ? null : PrinterResult.fromJson(json['apiResult'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PrinterPageModelToJson(PrinterPageModel instance) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.apiResult,
};

PrinterResult _$ApiResultFromJson(Map<String, dynamic> json) => PrinterResult(
  total: (json['total'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)?.map((e) => PrinterData.fromJson(e as Map<String, dynamic>)).toList(),
  hasMore: json['has_more'] as bool?,
);

Map<String, dynamic> _$ApiResultToJson(PrinterResult instance) => <String, dynamic>{
  'total': instance.total,
  'per_page': instance.perPage,
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'data': instance.data,
  'has_more': instance.hasMore,
};
