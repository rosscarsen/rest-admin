// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockData _$StockDataFromJson(Map<String, dynamic> json) => StockData(
  mPhone: Functions.asString(json['mPhone']),
  mName: Functions.asString(json['mName']),
  mAddress: Functions.asString(json['mAddress']),
  mAttn: Functions.asString(json['mAttn']),
  mFax: json['mFax'] as String?,
  mZip: json['mZip,fromJson: Functions.asString'] as String?,
  mEmail: Functions.asString(json['mEmail']),
  mRemarks: Functions.asString(json['mRemarks']),
  mCode: Functions.asString(json['mCode']),
  tStockId: Functions.asString(json['T_Stock_ID']),
  mSalesMemoFooter: Functions.asString(json['mSalesMemo_Footer']),
  mSalesMemoRemarks: Functions.asString(json['mSalesMemo_Remarks']),
  mNonActive: Functions.asString(json['mNon_Active']),
  mFloorplanPreFix: Functions.asString(json['mFloorplan_PreFix']),
  mRefNo: Functions.asString(json['mRefNo']),
  mKitchenLabel: Functions.asString(json['mKitchenLabel']),
);

Map<String, dynamic> _$StockDataToJson(StockData instance) => <String, dynamic>{
  'mPhone': instance.mPhone,
  'mName': instance.mName,
  'mAddress': instance.mAddress,
  'mAttn': instance.mAttn,
  'mFax': instance.mFax,
  'mZip,fromJson: Functions.asString': instance.mZip,
  'mEmail': instance.mEmail,
  'mRemarks': instance.mRemarks,
  'mCode': instance.mCode,
  'T_Stock_ID': instance.tStockId,
  'mSalesMemo_Footer': instance.mSalesMemoFooter,
  'mSalesMemo_Remarks': instance.mSalesMemoRemarks,
  'mNon_Active': instance.mNonActive,
  'mFloorplan_PreFix': instance.mFloorplanPreFix,
  'mRefNo': instance.mRefNo,
  'mKitchenLabel': instance.mKitchenLabel,
};
