// To parse this JSON data, do
//
//     final tablesEditModel = tablesEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../utils/functions.dart';
import '../stock/stock_data.dart';
import 'tables_data.dart';

part 'tables_edit_model.g.dart';

TablesEditModel tablesEditModelFromJson(String str) => TablesEditModel.fromJson(json.decode(str));

String tablesEditModelToJson(TablesEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class TablesEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  TablesEditResult? apiResult;

  TablesEditModel({this.status, this.msg, this.apiResult});

  factory TablesEditModel.fromJson(Map<String, dynamic> json) => _$TablesEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$TablesEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TablesEditResult extends TablesData {
  List<StockData>? allStock;

  TablesEditResult({
    super.mTableNo,
    super.mTableName,
    super.mLimitcost,
    super.mServCharge,
    super.mServer,
    super.mMaxNum,
    super.mLeft,
    super.mTop,
    super.mWidth,
    super.mHeight,
    super.mShape,
    super.mLayer,
    super.mTables,
    super.mStockCode,
    super.mId,
    super.mToGo,
    super.mDiscount,
    super.mCustomerCode,
    super.mNoColor,
    super.mUpdateTime,
    super.mByPerson,
    super.mProductCode,
    super.mDept,
    super.mType,
    super.day1,
    super.day2,
    super.day3,
    super.day4,
    super.day5,
    super.day6,
    super.day7,
    super.mDateTimeStart,
    super.mDateTimeEnd,
    this.allStock,
  });

  factory TablesEditResult.fromJson(Map<String, dynamic> json) => _$TablesEditResultFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TablesEditResultToJson(this);
}
