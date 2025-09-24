// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierPageModel _$SupplierPageModelFromJson(Map<String, dynamic> json) =>
    SupplierPageModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : SupplierApiResult.fromJson(
              json['apiResult'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SupplierPageModelToJson(SupplierPageModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

SupplierApiResult _$SupplierApiResultFromJson(Map<String, dynamic> json) =>
    SupplierApiResult(
      total: (json['total'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SupplierData.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$SupplierApiResultToJson(SupplierApiResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'has_more': instance.hasMore,
    };
