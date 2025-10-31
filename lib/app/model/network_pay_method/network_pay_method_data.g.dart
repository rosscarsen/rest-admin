// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_pay_method_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkPayMethodData _$NetworkPayMethodDataFromJson(
  Map<String, dynamic> json,
) => NetworkPayMethodData(
  id: Functions.asString(json['id']),
  tSupplier: Functions.asString(json['t_supplier']),
  tPaytype: Functions.asString(json['t_paytype']),
);

Map<String, dynamic> _$NetworkPayMethodDataToJson(
  NetworkPayMethodData instance,
) => <String, dynamic>{
  'id': instance.id,
  't_supplier': instance.tSupplier,
  't_paytype': instance.tPaytype,
};
