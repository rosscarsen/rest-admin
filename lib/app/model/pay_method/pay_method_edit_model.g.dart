// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_method_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayMethodEditModel _$PayMethodEditModelFromJson(Map<String, dynamic> json) =>
    PayMethodEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : PayMethodEditResult.fromJson(
              json['apiResult'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PayMethodEditModelToJson(PayMethodEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult,
    };

PayMethodEditResult _$PayMethodEditResultFromJson(Map<String, dynamic> json) =>
    PayMethodEditResult(
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
        mNoDrawer: json['mNoDrawer'] == null
            ? '0'
            : Functions.asString(json['mNoDrawer']),
        tPaytypeOnline: Functions.asString(json['t_paytype_online']),
        mHide: json['mHide'] == null ? '0' : Functions.asString(json['mHide']),
        networkPayMethod: (json['networkPayMethod'] as List<dynamic>?)
            ?.map(
              (e) => NetworkPayMethodData.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      )
      ..connectList = (json['connectList'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$PayMethodEditResultToJson(
  PayMethodEditResult instance,
) => <String, dynamic>{
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
  'networkPayMethod': instance.networkPayMethod
      ?.map((e) => e.toJson())
      .toList(),
  'connectList': instance.connectList,
};
