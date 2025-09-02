// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_method_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayMethodData _$PayMethodDataFromJson(Map<String, dynamic> json) =>
    PayMethodData(
      mPayType: Functions.asString(json['mPayType']),
      tPayTypeId: Functions.asString(json['T_PayType_ID']),
      mSort: Functions.asString(json['mSort']),
      mPrePaid: json['mPrePaid'] == null
          ? '0'
          : Functions.asString(json['mPrePaid']),
      mCreditCart: Functions.asString(json['mCreditCart']),
      mCardType: json['mCardType'] == null
          ? '0'
          : Functions.asString(json['mCardType']),
      mCom: Functions.asString(json['mCom']),
      mNoDrawer:
          json['mNoDrawer'] as String? ?? '0, fromJson: Functions.asString',
      tPaytypeOnline: Functions.asString(json['t_paytype_online']),
      mHide: json['mHide'] == null ? '0' : Functions.asString(json['mHide']),
    );

Map<String, dynamic> _$PayMethodDataToJson(PayMethodData instance) =>
    <String, dynamic>{
      'mPayType': instance.mPayType,
      'T_PayType_ID': instance.tPayTypeId,
      'mSort': instance.mSort,
      'mPrePaid': instance.mPrePaid,
      'mCreditCart': instance.mCreditCart,
      'mCardType': instance.mCardType,
      'mCom': instance.mCom,
      'mNoDrawer': instance.mNoDrawer,
      't_paytype_online': instance.tPaytypeOnline,
      'mHide': instance.mHide,
    };
