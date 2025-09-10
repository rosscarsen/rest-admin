// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepositList _$DepositListFromJson(Map<String, dynamic> json) => DepositList(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  depositResult: json['apiResult'] == null
      ? null
      : DepositResult.fromJson(json['apiResult'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DepositListToJson(DepositList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.depositResult?.toJson(),
    };

DepositResult _$DepositResultFromJson(Map<String, dynamic> json) =>
    DepositResult(
      total: (json['total'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      depositData: (json['data'] as List<dynamic>?)
          ?.map((e) => DepositData.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool?,
    );

Map<String, dynamic> _$DepositResultToJson(DepositResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'data': instance.depositData?.map((e) => e.toJson()).toList(),
      'has_more': instance.hasMore,
    };

DepositData _$DepositDataFromJson(Map<String, dynamic> json) => DepositData(
  tCustomerId: Functions.asString(json['t_customer_id']),
  mItem: Functions.asString(json['mItem']),
  mDepositDate: Functions.asString(json['mDeposit_Date']),
  mParticular: Functions.asString(json['mParticular']),
  mAmount: Functions.asString(json['mAmount']),
  mRefNo: Functions.asString(json['mRef_No']),
  mRemark: Functions.asString(json['mRemark']),
);

Map<String, dynamic> _$DepositDataToJson(DepositData instance) =>
    <String, dynamic>{
      't_customer_id': instance.tCustomerId,
      'mItem': instance.mItem,
      'mDeposit_Date': instance.mDepositDate,
      'mParticular': instance.mParticular,
      'mAmount': instance.mAmount,
      'mRef_No': instance.mRefNo,
      'mRemark': instance.mRemark,
    };
