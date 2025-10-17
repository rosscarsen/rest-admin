// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_meal_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMealPageModel _$SetMealPageModelFromJson(Map<String, dynamic> json) =>
    SetMealPageModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : SetMealResult.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetMealPageModelToJson(SetMealPageModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult?.toJson(),
    };

SetMealResult _$SetMealResultFromJson(Map<String, dynamic> json) =>
    SetMealResult(
      total: (json['total'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SetMealData.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$SetMealResultToJson(SetMealResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'has_more': instance.hasMore,
    };
