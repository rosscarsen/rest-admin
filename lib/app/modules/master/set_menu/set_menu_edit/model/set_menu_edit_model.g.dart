// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_menu_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMenuEditModel _$SetMenuEditModelFromJson(Map<String, dynamic> json) =>
    SetMenuEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : SetMenuEdit.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetMenuEditModelToJson(SetMenuEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult?.toJson(),
    };

SetMenuEdit _$SetMenuEditFromJson(Map<String, dynamic> json) => SetMenuEdit(
  tSetmenuId: Functions.asString(json['T_setmenu_ID']),
  mCode: Functions.asString(json['mCode']),
  mDesc: Functions.asString(json['mDesc']),
  mDateCreate: Functions.asString(json['mDate_Create']),
  mDateModify: Functions.asString(json['mDate_Modify']),
  setLimit: (json['setLimit'] as List<dynamic>?)
      ?.map((e) => SetLimit.fromJson(e as Map<String, dynamic>))
      .toList(),
  setMenuDetail: (json['setMenuDetail'] as List<dynamic>?)
      ?.map((e) => SetMenuDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SetMenuEditToJson(SetMenuEdit instance) =>
    <String, dynamic>{
      'T_setmenu_ID': instance.tSetmenuId,
      'mCode': instance.mCode,
      'mDesc': instance.mDesc,
      'mDate_Create': instance.mDateCreate,
      'mDate_Modify': instance.mDateModify,
      'setLimit': instance.setLimit?.map((e) => e.toJson()).toList(),
      'setMenuDetail': instance.setMenuDetail?.map((e) => e.toJson()).toList(),
    };

SetLimit _$SetLimitFromJson(Map<String, dynamic> json) => SetLimit(
  setLimitId: Functions.asString(json['set_limit_id']),
  tSetmenuId: Functions.asString(json['T_setmenu_ID']),
  mStep: Functions.asString(json['mStep']),
  limitMax: Functions.asString(json['limit_max']),
  obligatory: Functions.asString(json['obligatory']),
  zhtw: Functions.asString(json['zhtw']),
  enus: Functions.asString(json['enus']),
);

Map<String, dynamic> _$SetLimitToJson(SetLimit instance) => <String, dynamic>{
  'set_limit_id': instance.setLimitId,
  'T_setmenu_ID': instance.tSetmenuId,
  'mStep': instance.mStep,
  'limit_max': instance.limitMax,
  'obligatory': instance.obligatory,
  'zhtw': instance.zhtw,
  'enus': instance.enus,
};

SetMenuDetail _$SetMenuDetailFromJson(Map<String, dynamic> json) =>
    SetMenuDetail(
      tSetmenuId: Functions.asString(json['T_setmenu_ID']),
      mName: Functions.asString(json['mName']),
      mBarcode: Functions.asString(json['mBarcode']),
      mPrice: Functions.asString(json['mPrice']),
      mPrice2: Functions.asString(json['mPrice2']),
      mQty: Functions.asString(json['mQty']),
      mRemarks: Functions.asString(json['mRemarks']),
      mProductCode: Functions.asString(json['mProduct_Code']),
      mId: Functions.asString(json['mID']),
      mFlag: Functions.asString(json['mFlag']),
      mTime: Functions.asString(json['mTime']),
      mPCode: Functions.asString(json['mPCode']),
      mStep: Functions.asString(json['mStep']),
      mDefault: Functions.asString(json['mDefault']),
      mSort: Functions.asString(json['mSort']),
      soldOut: Functions.asString(json['Sold_out']),
    );

Map<String, dynamic> _$SetMenuDetailToJson(SetMenuDetail instance) =>
    <String, dynamic>{
      'T_setmenu_ID': instance.tSetmenuId,
      'mName': instance.mName,
      'mBarcode': instance.mBarcode,
      'mPrice': instance.mPrice,
      'mPrice2': instance.mPrice2,
      'mQty': instance.mQty,
      'mRemarks': instance.mRemarks,
      'mProduct_Code': instance.mProductCode,
      'mID': instance.mId,
      'mFlag': instance.mFlag,
      'mTime': instance.mTime,
      'mPCode': instance.mPCode,
      'mStep': instance.mStep,
      'mDefault': instance.mDefault,
      'mSort': instance.mSort,
      'Sold_out': instance.soldOut,
    };
