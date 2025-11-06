// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TablesData _$TablesDataFromJson(Map<String, dynamic> json) => TablesData(
  mTableNo: Functions.asString(json['mTableNo']),
  mTableName: Functions.asString(json['mTableName']),
  mLimitcost: Functions.asString(json['mLimitcost']),
  mServCharge: Functions.asString(json['mServCharge']),
  mServer: Functions.asString(json['mServer']),
  mMaxNum: Functions.asString(json['mMaxNum']),
  mLeft: json['mLeft'] == null ? '0' : Functions.asString(json['mLeft']),
  mTop: json['mTop'] == null ? '0' : Functions.asString(json['mTop']),
  mWidth: json['mWidth'] == null ? '500' : Functions.asString(json['mWidth']),
  mHeight: json['mHeight'] == null
      ? '500'
      : Functions.asString(json['mHeight']),
  mShape: json['mShape'] == null ? '1' : Functions.asString(json['mShape']),
  mLayer: Functions.asString(json['mLayer']),
  mTables: Functions.asString(json['mTables']),
  mStockCode: Functions.asString(json['mStockCode']),
  mId: Functions.asString(json['mId']),
  mToGo: json['mToGo'] == null ? '0' : Functions.asString(json['mToGo']),
  mDiscount: Functions.asString(json['mDiscount']),
  mCustomerCode: Functions.asString(json['mCustomerCode']),
  mNoColor: json['mNoColor'] == null
      ? '0'
      : Functions.asString(json['mNoColor']),
  mUpdateTime: Functions.asString(json['mUpdateTime']),
  mByPerson: json['mByPerson'] == null
      ? '0'
      : Functions.asString(json['mByPerson']),
  mProductCode: Functions.asString(json['mProduct_Code']),
  mDept: Functions.asString(json['mDept']),
  mType: json['mType'] == null ? '0' : Functions.asString(json['mType']),
  day1: Functions.asString(json['day1']),
  day2: Functions.asString(json['day2']),
  day3: Functions.asString(json['day3']),
  day4: Functions.asString(json['day4']),
  day5: Functions.asString(json['day5']),
  day6: Functions.asString(json['day6']),
  day7: Functions.asString(json['day7']),
  mDateTimeStart: Functions.asString(json['mDateTimeStart']),
  mDateTimeEnd: Functions.asString(json['mDateTimeEnd']),
);

Map<String, dynamic> _$TablesDataToJson(TablesData instance) =>
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
      'day1': Functions.toBool(instance.day1),
      'day2': Functions.toBool(instance.day2),
      'day3': Functions.toBool(instance.day3),
      'day4': Functions.toBool(instance.day4),
      'day5': Functions.toBool(instance.day5),
      'day6': Functions.toBool(instance.day6),
      'day7': Functions.toBool(instance.day7),
      'mDateTimeStart': instance.mDateTimeStart,
      'mDateTimeEnd': instance.mDateTimeEnd,
    };
