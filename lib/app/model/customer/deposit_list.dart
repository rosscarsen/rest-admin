// To parse this JSON data, do
//
//     final depositList = depositListFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../utils/functions.dart';

part 'deposit_list.g.dart';

DepositList depositListFromJson(String str) => DepositList.fromJson(json.decode(str));

String depositListToJson(DepositList data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class DepositList {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final DepositResult? depositResult;

  DepositList({this.status, this.msg, this.depositResult});

  DepositList copyWith({int? status, String? msg, DepositResult? depositResult}) => DepositList(
    status: status ?? this.status,
    msg: msg ?? this.msg,
    depositResult: depositResult ?? this.depositResult,
  );

  factory DepositList.fromJson(Map<String, dynamic> json) => _$DepositListFromJson(json);

  Map<String, dynamic> toJson() => _$DepositListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DepositResult {
  @JsonKey(name: "total")
  final int? total;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "current_page")
  final int? currentPage;
  @JsonKey(name: "last_page")
  final int? lastPage;
  @JsonKey(name: "data")
  final List<DepositData>? depositData;
  @JsonKey(name: "has_more")
  final bool? hasMore;

  DepositResult({this.total, this.perPage, this.currentPage, this.lastPage, this.depositData, this.hasMore});

  DepositResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<DepositData>? depositData,
    bool? hasMore,
  }) => DepositResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    depositData: depositData ?? this.depositData,
    hasMore: hasMore ?? this.hasMore,
  );

  factory DepositResult.fromJson(Map<String, dynamic> json) => _$DepositResultFromJson(json);

  Map<String, dynamic> toJson() => _$DepositResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DepositData {
  @JsonKey(name: "t_customer_id", fromJson: Functions.asString)
  final String? tCustomerId;
  @JsonKey(name: "mItem", fromJson: Functions.asString)
  final String? mItem;
  @JsonKey(name: "mDeposit_Date", fromJson: Functions.asString)
  final String? mDepositDate;
  @JsonKey(name: "mParticular", fromJson: Functions.asString)
  final String? mParticular;
  @JsonKey(name: "mAmount", fromJson: Functions.asString)
  final String? mAmount;
  @JsonKey(name: "mRef_No", fromJson: Functions.asString)
  final String? mRefNo;
  @JsonKey(name: "mRemark", fromJson: Functions.asString)
  final String? mRemark;

  DepositData({
    this.tCustomerId,
    this.mItem,
    this.mDepositDate,
    this.mParticular,
    this.mAmount,
    this.mRefNo,
    this.mRemark,
  });

  DepositData copyWith({
    String? tCustomerId,
    String? mItem,
    String? mDepositDate,
    String? mParticular,
    String? mAmount,
    String? mRefNo,
    String? mRemark,
  }) => DepositData(
    tCustomerId: tCustomerId ?? this.tCustomerId,
    mItem: mItem ?? this.mItem,
    mDepositDate: mDepositDate ?? this.mDepositDate,
    mParticular: mParticular ?? this.mParticular,
    mAmount: mAmount ?? this.mAmount,
    mRefNo: mRefNo ?? this.mRefNo,
    mRemark: mRemark ?? this.mRemark,
  );

  factory DepositData.fromJson(Map<String, dynamic> json) => _$DepositDataFromJson(json);

  Map<String, dynamic> toJson() => _$DepositDataToJson(this);
}
