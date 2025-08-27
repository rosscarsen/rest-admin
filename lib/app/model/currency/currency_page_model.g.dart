// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyPageModel _$CurrencyPageModelFromJson(Map<String, dynamic> json) =>
    CurrencyPageModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : ApiResult.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrencyPageModelToJson(CurrencyPageModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

ApiResult _$ApiResultFromJson(Map<String, dynamic> json) => ApiResult(
  total: (json['total'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CurrencyData.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMore: json['has_more'] as bool?,
);

Map<String, dynamic> _$ApiResultToJson(ApiResult instance) => <String, dynamic>{
  'total': instance.total,
  'per_page': instance.perPage,
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'data': instance.data,
  'has_more': instance.hasMore,
};
