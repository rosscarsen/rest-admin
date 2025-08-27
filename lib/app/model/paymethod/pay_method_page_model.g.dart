// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_method_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayMethodPageModel _$PayMethodPageModelFromJson(Map<String, dynamic> json) =>
    PayMethodPageModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : ApiResult.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayMethodPageModelToJson(PayMethodPageModel instance) =>
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
      ?.map((e) => PayMethodData.fromJson(e as Map<String, dynamic>))
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
