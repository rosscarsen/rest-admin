// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TablesEditModel _$TablesEditModelFromJson(Map<String, dynamic> json) =>
    TablesEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : TablesEditResult.fromJson(
              json['apiResult'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TablesEditModelToJson(TablesEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

TablesEditResult _$TablesEditResultFromJson(Map<String, dynamic> json) =>
    TablesEditResult(
      mTableNo: Functions.asString(json['mTableNo']),
      mTableName: Functions.asString(json['mTableName']),
      mLimitcost: Functions.asString(json['mLimitcost']),
      mServCharge: Functions.asString(json['mServCharge']),
      mServer: Functions.asString(json['mServer']),
      mMaxNum: Functions.asString(json['mMaxNum']),
      mLeft: Functions.asString(json['mLeft']),
      mTop: Functions.asString(json['mTop']),
      mWidth: Functions.asString(json['mWidth']),
      mHeight: Functions.asString(json['mHeight']),
      mShape: Functions.asString(json['mShape']),
      mLayer: Functions.asString(json['mLayer']),
      mTables: Functions.asString(json['mTables']),
      mStockCode: Functions.asString(json['mStockCode']),
      mId: Functions.asString(json['mId']),
      mToGo: Functions.asString(json['mToGo']),
      mDiscount: Functions.asString(json['mDiscount']),
      mCustomerCode: Functions.asString(json['mCustomerCode']),
      mNoColor: Functions.asString(json['mNoColor']),
      mUpdateTime: Functions.asString(json['mUpdateTime']),
      mByPerson: Functions.asString(json['mByPerson']),
      mProductCode: Functions.asString(json['mProduct_Code']),
      mDept: Functions.asString(json['mDept']),
      mType: Functions.asString(json['mType']),
      day1: Functions.asString(json['day1']),
      day2: Functions.asString(json['day2']),
      day3: Functions.asString(json['day3']),
      day4: Functions.asString(json['day4']),
      day5: Functions.asString(json['day5']),
      day6: Functions.asString(json['day6']),
      day7: Functions.asString(json['day7']),
      mDateTimeStart: Functions.asString(json['mDateTimeStart']),
      mDateTimeEnd: Functions.asString(json['mDateTimeEnd']),
      allStock: (json['allStock'] as List<dynamic>?)
          ?.map((e) => StockData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TablesEditResultToJson(TablesEditResult instance) =>
    <String, dynamic>{
      'mTableNo': instance.mTableNo,
      'mTableName': instance.mTableName,
      'mLimitcost': instance.mLimitcost,
      'mServCharge': instance.mServCharge,
      'mServer': instance.mServer,
      'mMaxNum': instance.mMaxNum,
      'mLeft': instance.mLeft,
      'mTop': instance.mTop,
      'mWidth': instance.mWidth,
      'mHeight': instance.mHeight,
      'mShape': instance.mShape,
      'mLayer': instance.mLayer,
      'mTables': instance.mTables,
      'mStockCode': instance.mStockCode,
      'mId': instance.mId,
      'mToGo': instance.mToGo,
      'mDiscount': instance.mDiscount,
      'mCustomerCode': instance.mCustomerCode,
      'mNoColor': instance.mNoColor,
      'mUpdateTime': instance.mUpdateTime,
      'mByPerson': instance.mByPerson,
      'mProduct_Code': instance.mProductCode,
      'mDept': instance.mDept,
      'mType': instance.mType,
      'day1': instance.day1,
      'day2': instance.day2,
      'day3': instance.day3,
      'day4': instance.day4,
      'day5': instance.day5,
      'day6': instance.day6,
      'day7': instance.day7,
      'mDateTimeStart': instance.mDateTimeStart,
      'mDateTimeEnd': instance.mDateTimeEnd,
      'allStock': instance.allStock?.map((e) => e.toJson()).toList(),
    };
