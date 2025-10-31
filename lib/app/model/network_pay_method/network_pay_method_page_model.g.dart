// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_pay_method_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkPayMethodPageModel _$NetworkPayMethodPageModelFromJson(
  Map<String, dynamic> json,
) => NetworkPayMethodPageModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  apiResult: json['apiResult'] == null
      ? null
      : NetworkPayMethodResult.fromJson(
          json['apiResult'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NetworkPayMethodPageModelToJson(
  NetworkPayMethodPageModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.apiResult,
};

NetworkPayMethodResult _$NetworkPayMethodResultFromJson(
  Map<String, dynamic> json,
) => NetworkPayMethodResult(
  total: (json['total'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NetworkPayMethodData.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMore: json['has_more'] as bool?,
);

Map<String, dynamic> _$NetworkPayMethodResultToJson(
  NetworkPayMethodResult instance,
) => <String, dynamic>{
  'total': instance.total,
  'per_page': instance.perPage,
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'data': instance.data,
  'has_more': instance.hasMore,
};
