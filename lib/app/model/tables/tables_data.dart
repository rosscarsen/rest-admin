import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'tables_data.g.dart';

@JsonSerializable(explicitToJson: true)
class TablesData {
  @JsonKey(name: "mTableNo", fromJson: Functions.asString)
  String? mTableNo;
  @JsonKey(name: "mTableName", fromJson: Functions.asString)
  String? mTableName;
  @JsonKey(name: "mLimitcost", fromJson: Functions.asString)
  String? mLimitcost;
  @JsonKey(name: "mServCharge", fromJson: Functions.asString)
  String? mServCharge;
  @JsonKey(name: "mServer", fromJson: Functions.asString)
  String? mServer;
  @JsonKey(name: "mMaxNum", fromJson: Functions.asString)
  String? mMaxNum;
  @JsonKey(name: "mLeft", defaultValue: "0", fromJson: Functions.asString)
  String? mLeft;
  @JsonKey(name: "mTop", defaultValue: "0", fromJson: Functions.asString)
  String? mTop;
  @JsonKey(name: "mWidth", defaultValue: "500", fromJson: Functions.asString)
  String? mWidth;
  @JsonKey(name: "mHeight", defaultValue: "500", fromJson: Functions.asString)
  String? mHeight;
  @JsonKey(name: "mShape", defaultValue: "1", fromJson: Functions.asString)
  String? mShape;
  @JsonKey(name: "mLayer", fromJson: Functions.asString)
  String? mLayer;
  @JsonKey(name: "mTables", fromJson: Functions.asString)
  String? mTables;
  @JsonKey(name: "mStockCode", fromJson: Functions.asString)
  String? mStockCode;
  @JsonKey(name: "mId", fromJson: Functions.asString)
  String? mId;
  @JsonKey(name: "mToGo", defaultValue: "0", fromJson: Functions.asString)
  String? mToGo;
  @JsonKey(name: "mDiscount", fromJson: Functions.asString)
  String? mDiscount;
  @JsonKey(name: "mCustomerCode", fromJson: Functions.asString)
  String? mCustomerCode;
  @JsonKey(name: "mNoColor", defaultValue: "0", fromJson: Functions.asString)
  String? mNoColor;
  @JsonKey(name: "mUpdateTime", fromJson: Functions.asString)
  String? mUpdateTime;
  @JsonKey(name: "mByPerson", defaultValue: "0", fromJson: Functions.asString)
  String? mByPerson;
  @JsonKey(name: "mProduct_Code", fromJson: Functions.asString)
  String? mProductCode;
  @JsonKey(name: "mDept", fromJson: Functions.asString)
  String? mDept;
  @JsonKey(name: "mType", defaultValue: "0", fromJson: Functions.asString)
  String? mType;
  @JsonKey(name: "day1", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day1;
  @JsonKey(name: "day2", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day2;
  @JsonKey(name: "day3", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day3;
  @JsonKey(name: "day4", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day4;
  @JsonKey(name: "day5", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day5;
  @JsonKey(name: "day6", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day6;
  @JsonKey(name: "day7", fromJson: Functions.asString, toJson: Functions.toBool)
  String? day7;
  @JsonKey(name: "mDateTimeStart", fromJson: Functions.asString)
  String? mDateTimeStart;
  @JsonKey(name: "mDateTimeEnd", fromJson: Functions.asString)
  String? mDateTimeEnd;

  TablesData({
    this.mTableNo,
    this.mTableName,
    this.mLimitcost,
    this.mServCharge,
    this.mServer,
    this.mMaxNum,
    this.mLeft,
    this.mTop,
    this.mWidth,
    this.mHeight,
    this.mShape,
    this.mLayer,
    this.mTables,
    this.mStockCode,
    this.mId,
    this.mToGo,
    this.mDiscount,
    this.mCustomerCode,
    this.mNoColor,
    this.mUpdateTime,
    this.mByPerson,
    this.mProductCode,
    this.mDept,
    this.mType,
    this.day1,
    this.day2,
    this.day3,
    this.day4,
    this.day5,
    this.day6,
    this.day7,
    this.mDateTimeStart,
    this.mDateTimeEnd,
  });

  factory TablesData.fromJson(Map<String, dynamic> json) => _$TablesDataFromJson(json);

  Map<String, dynamic> toJson() => _$TablesDataToJson(this);
}
