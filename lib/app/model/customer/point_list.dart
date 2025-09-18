// To parse this JSON data, do
//
//      depositList = depositListFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';

part 'point_list.g.dart';

PointList pointListFromJson(String str) => PointList.fromJson(json.decode(str));

String pointListToJson(PointList data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class PointList {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  PointResult? pointResult;

  PointList({this.status, this.msg, this.pointResult});

  PointList copyWith({int? status, String? msg, PointResult? pointResult}) =>
      PointList(status: status ?? this.status, msg: msg ?? this.msg, pointResult: pointResult ?? this.pointResult);

  factory PointList.fromJson(Map<String, dynamic> json) => _$PointListFromJson(json);

  Map<String, dynamic> toJson() => _$PointListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PointResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<PointData>? pointData;
  @JsonKey(name: "has_more")
  bool? hasMore;

  PointResult({this.total, this.perPage, this.currentPage, this.lastPage, this.pointData, this.hasMore});

  PointResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<PointData>? pointData,
    bool? hasMore,
  }) => PointResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    pointData: pointData ?? this.pointData,
    hasMore: hasMore ?? this.hasMore,
  );

  factory PointResult.fromJson(Map<String, dynamic> json) => _$PointResultFromJson(json);

  Map<String, dynamic> toJson() => _$PointResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PointData {
  @JsonKey(name: "t_customer_id", fromJson: Functions.asString)
  String? tCustomerId;
  @JsonKey(name: "mItem", fromJson: Functions.asString)
  String? mItem;
  @JsonKey(name: "mDeposit_Date", fromJson: Functions.asString)
  String? mDepositDate;
  @JsonKey(name: "mParticular", fromJson: Functions.asString)
  String? mParticular;
  @JsonKey(name: "mAmount", fromJson: Functions.asString)
  String? mAmount;
  @JsonKey(name: "mRef_No", fromJson: Functions.asString)
  String? mRefNo;
  @JsonKey(name: "mRemark", fromJson: Functions.asString)
  String? mRemark;

  PointData({
    this.tCustomerId,
    this.mItem,
    this.mDepositDate,
    this.mParticular,
    this.mAmount,
    this.mRefNo,
    this.mRemark,
  });

  PointData copyWith({
    String? tCustomerId,
    String? mItem,
    String? mDepositDate,
    String? mParticular,
    String? mAmount,
    String? mRefNo,
    String? mRemark,
  }) => PointData(
    tCustomerId: tCustomerId ?? this.tCustomerId,
    mItem: mItem ?? this.mItem,
    mDepositDate: mDepositDate ?? this.mDepositDate,
    mParticular: mParticular ?? this.mParticular,
    mAmount: mAmount ?? this.mAmount,
    mRefNo: mRefNo ?? this.mRefNo,
    mRemark: mRemark ?? this.mRemark,
  );

  factory PointData.fromJson(Map<String, dynamic> json) => _$PointDataFromJson(json);

  Map<String, dynamic> toJson() => _$PointDataToJson(this);

  void updateFromSource(PointData source) {
    if (source.tCustomerId != null) tCustomerId = source.tCustomerId;
    if (source.mItem != null) mItem = source.mItem;
    mDepositDate = source.mDepositDate;
    if (source.mParticular != null) mParticular = source.mParticular;
    mAmount = source.mAmount;
    mRefNo = source.mRefNo;
    mRemark = source.mRemark;
  }
}
