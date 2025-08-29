// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyData _$CurrencyDataFromJson(Map<String, dynamic> json) => CurrencyData(
  mDescription: Functions.asString(json['mDescription']),
  mCode: Functions.asString(json['mCode']),
  mRate: Functions.asString(json['mRate']),
  mDefault: json['mDefault'] == null
      ? '0'
      : Functions.asString(json['mDefault']),
  tMoneyCurrencyId: Functions.asString(json['T_MoneyCurrency_ID']),
);

Map<String, dynamic> _$CurrencyDataToJson(CurrencyData instance) =>
    <String, dynamic>{
      'mDescription': instance.mDescription,
      'mCode': instance.mCode,
      'mRate': instance.mRate,
      'mDefault': instance.mDefault,
      'T_MoneyCurrency_ID': instance.tMoneyCurrencyId,
    };
