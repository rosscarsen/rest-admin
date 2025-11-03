// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TablesPageModel _$TablesPageModelFromJson(Map<String, dynamic> json) =>
    TablesPageModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : TablesResult.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TablesPageModelToJson(TablesPageModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

TablesResult _$TablesResultFromJson(Map<String, dynamic> json) => TablesResult(
  total: (json['total'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => TablesData.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMore: json['has_more'] as bool?,
  allStock: (json['allStock'] as List<dynamic>?)
      ?.map((e) => StockData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TablesResultToJson(TablesResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'has_more': instance.hasMore,
      'allStock': instance.allStock?.map((e) => e.toJson()).toList(),
    };
