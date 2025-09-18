// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointList _$PointListFromJson(Map<String, dynamic> json) => PointList(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  pointResult: json['apiResult'] == null
      ? null
      : PointResult.fromJson(json['apiResult'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PointListToJson(PointList instance) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.pointResult?.toJson(),
};

PointResult _$PointResultFromJson(Map<String, dynamic> json) => PointResult(
  total: (json['total'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  pointData: (json['data'] as List<dynamic>?)
      ?.map((e) => PointData.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMore: json['has_more'] as bool?,
);

Map<String, dynamic> _$PointResultToJson(PointResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.pointData?.map((e) => e.toJson()).toList(),
      'has_more': instance.hasMore,
    };

PointData _$PointDataFromJson(Map<String, dynamic> json) => PointData(
  tCustomerId: Functions.asString(json['t_customer_id']),
  mItem: Functions.asString(json['mItem']),
  mDepositDate: Functions.asString(json['mDeposit_Date']),
  mParticular: Functions.asString(json['mParticular']),
  mAmount: Functions.asString(json['mAmount']),
  mRefNo: Functions.asString(json['mRef_No']),
  mRemark: Functions.asString(json['mRemark']),
);

Map<String, dynamic> _$PointDataToJson(PointData instance) => <String, dynamic>{
  't_customer_id': instance.tCustomerId,
  'mItem': instance.mItem,
  'mDeposit_Date': instance.mDepositDate,
  'mParticular': instance.mParticular,
  'mAmount': instance.mAmount,
  'mRef_No': instance.mRefNo,
  'mRemark': instance.mRemark,
};
