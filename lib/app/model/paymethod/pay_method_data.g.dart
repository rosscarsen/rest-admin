// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_method_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayMethodData _$PayMethodDataFromJson(Map<String, dynamic> json) =>
    PayMethodData(
      mPayType: json['mPayType'] as String?,
      tPayTypeId: (json['T_PayType_ID'] as num?)?.toInt(),
      mSort: (json['mSort'] as num?)?.toInt(),
      mPrePaid: (json['mPrePaid'] as num?)?.toInt() ?? 0,
      mCreditCart: (json['mCreditCart'] as num?)?.toInt(),
      mCardType: (json['mCardType'] as num?)?.toInt() ?? 0,
      mCom: json['mCom'] as String?,
      mNoDrawer: (json['mNoDrawer'] as num?)?.toInt() ?? 0,
      tPaytypeOnline: json['t_paytype_online'] as String?,
      mHide: (json['mHide'] as num?)?.toInt() ?? 0,
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
