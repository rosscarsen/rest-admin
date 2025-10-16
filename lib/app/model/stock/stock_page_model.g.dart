// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockPageModel _$StockPageModelFromJson(Map<String, dynamic> json) =>
    StockPageModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : StockApiResult.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockPageModelToJson(StockPageModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

StockApiResult _$StockApiResultFromJson(Map<String, dynamic> json) =>
    StockApiResult(
      total: (json['total'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StockData.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$StockApiResultToJson(StockApiResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.data,
      'has_more': instance.hasMore,
    };
