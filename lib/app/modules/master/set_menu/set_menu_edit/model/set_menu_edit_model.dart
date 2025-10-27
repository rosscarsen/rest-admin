// To parse this JSON data, do
//
//     final setMenuEditModel = setMenuEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../../../../utils/functions.dart';

part 'set_menu_edit_model.g.dart';

SetMenuEditModel setMenuEditModelFromJson(String str) => SetMenuEditModel.fromJson(json.decode(str));

String setMenuEditModelToJson(SetMenuEditModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class SetMenuEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SetMenuEdit? apiResult;

  SetMenuEditModel({this.status, this.msg, this.apiResult});

  factory SetMenuEditModel.fromJson(Map<String, dynamic> json) => _$SetMenuEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$SetMenuEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetMenuEdit {
  @JsonKey(name: "T_setmenu_ID", fromJson: Functions.asString)
  String? tSetmenuId;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "mDesc", fromJson: Functions.asString)
  String? mDesc;
  @JsonKey(name: "mDate_Create", fromJson: Functions.asString)
  String? mDateCreate;
  @JsonKey(name: "mDate_Modify", fromJson: Functions.asString)
  String? mDateModify;
  @JsonKey(name: "setLimit")
  List<SetLimit>? setLimit;
  @JsonKey(name: "setMenuDetail")
  List<SetMenuDetail>? setMenuDetail;

  SetMenuEdit({
    this.tSetmenuId,
    this.mCode,
    this.mDesc,
    this.mDateCreate,
    this.mDateModify,
    this.setLimit,
    this.setMenuDetail,
  });

  factory SetMenuEdit.fromJson(Map<String, dynamic> json) => _$SetMenuEditFromJson(json);

  Map<String, dynamic> toJson() => _$SetMenuEditToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetLimit {
  @JsonKey(name: "set_limit_id", fromJson: Functions.asString)
  String? setLimitId;
  @JsonKey(name: "T_setmenu_ID", fromJson: Functions.asString)
  String? tSetmenuId;
  @JsonKey(name: "mStep", fromJson: Functions.asString)
  String? mStep;
  @JsonKey(name: "limit_max", fromJson: Functions.asString)
  String? limitMax;
  @JsonKey(name: "obligatory", fromJson: Functions.asString)
  String? obligatory;
  @JsonKey(name: "zhtw", fromJson: Functions.asString)
  String? zhtw;
  @JsonKey(name: "enus", fromJson: Functions.asString)
  String? enus;

  SetLimit({this.setLimitId, this.tSetmenuId, this.mStep, this.limitMax, this.obligatory, this.zhtw, this.enus});

  factory SetLimit.fromJson(Map<String, dynamic> json) => _$SetLimitFromJson(json);

  Map<String, dynamic> toJson() => _$SetLimitToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetMenuDetail {
  @JsonKey(name: "T_setmenu_ID", fromJson: Functions.asString)
  String? tSetmenuId;
  @JsonKey(name: "mName", fromJson: Functions.asString)
  String? mName;
  @JsonKey(name: "mBarcode", fromJson: Functions.asString)
  String? mBarcode;
  @JsonKey(name: "mPrice", fromJson: Functions.asString)
  String? mPrice;
  @JsonKey(name: "mPrice2", fromJson: Functions.asString)
  String? mPrice2;
  @JsonKey(name: "mQty", fromJson: Functions.asString)
  String? mQty;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mProduct_Code", fromJson: Functions.asString)
  String? mProductCode;
  @JsonKey(name: "mID", fromJson: Functions.asString)
  String? mId;
  @JsonKey(name: "mFlag", fromJson: Functions.asString)
  String? mFlag;
  @JsonKey(name: "mTime", fromJson: Functions.asString)
  String? mTime;
  @JsonKey(name: "mPCode", fromJson: Functions.asString)
  String? mPCode;
  @JsonKey(name: "mStep", fromJson: Functions.asString)
  String? mStep;
  @JsonKey(name: "mDefault", fromJson: Functions.asString)
  String? mDefault;
  @JsonKey(name: "mSort", fromJson: Functions.asString)
  String? mSort;
  @JsonKey(name: "Sold_out", fromJson: Functions.asString)
  String? soldOut;

  SetMenuDetail({
    this.tSetmenuId,
    this.mName,
    this.mBarcode,
    this.mPrice,
    this.mPrice2,
    this.mQty,
    this.mRemarks,
    this.mProductCode,
    this.mId,
    this.mFlag,
    this.mTime,
    this.mPCode,
    this.mStep,
    this.mDefault,
    this.mSort,
    this.soldOut,
  });

  factory SetMenuDetail.fromJson(Map<String, dynamic> json) => _$SetMenuDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SetMenuDetailToJson(this);
  void copyFrom(SetMenuDetail other) {
    tSetmenuId = other.tSetmenuId;
    mName = other.mName;
    mBarcode = other.mBarcode;
    mPrice = other.mPrice;
    mPrice2 = other.mPrice2;
    mQty = other.mQty;
    mRemarks = other.mRemarks;
    mProductCode = other.mProductCode;
    mId = other.mId;
    mFlag = other.mFlag;
    mTime = other.mTime;
    mPCode = other.mPCode;
    mStep = other.mStep;
    mDefault = other.mDefault;
    mSort = other.mSort;
    soldOut = other.soldOut;
  }
}
