// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyData _$CurrencyDataFromJson(Map<String, dynamic> json) => CurrencyData(
  mDescription: json['mDescription'] as String?,
  mCode: json['mCode'] as String?,
  mRate: json['mRate'] as String?,
  mDefault: (json['mDefault'] as num?)?.toInt() ?? 0,
  tMoneyCurrencyId: (json['T_MoneyCurrency_ID'] as num?)?.toInt(),
);

Map<String, dynamic> _$CurrencyDataToJson(CurrencyData instance) =>
    <String, dynamic>{
      'mDescription': instance.mDescription,
      'mCode': instance.mCode,
      'mRate': instance.mRate,
      'mDefault': instance.mDefault,
      'T_MoneyCurrency_ID': instance.tMoneyCurrencyId,
    };
