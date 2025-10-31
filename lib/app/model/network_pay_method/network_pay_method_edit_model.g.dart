// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_pay_method_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkPayMethodEditModel _$NetworkPayMethodEditModelFromJson(
  Map<String, dynamic> json,
) => NetworkPayMethodEditModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  apiResult: json['apiResult'] == null
      ? null
      : NetworkPayMethodEditResult.fromJson(
          json['apiResult'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NetworkPayMethodEditModelToJson(
  NetworkPayMethodEditModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'msg': instance.msg,
  'apiResult': instance.apiResult,
};

NetworkPayMethodEditResult _$NetworkPayMethodEditResultFromJson(
  Map<String, dynamic> json,
) => NetworkPayMethodEditResult(
  id: Functions.asString(json['id']),
  tSupplier: Functions.asString(json['t_supplier']),
  tPaytype: Functions.asString(json['t_paytype']),
  allSupplier: (json['allSupplier'] as List<dynamic>?)
      ?.map((e) => AllSupplier.fromJson(e as Map<String, dynamic>))
      .toList(),
  allPayMethod: (json['allPayMethod'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$NetworkPayMethodEditResultToJson(
  NetworkPayMethodEditResult instance,
) => <String, dynamic>{
  'id': instance.id,
  't_supplier': instance.tSupplier,
  't_paytype': instance.tPaytype,
  'allSupplier': instance.allSupplier,
  'allPayMethod': instance.allPayMethod,
};

AllSupplier _$AllSupplierFromJson(Map<String, dynamic> json) =>
    AllSupplier(tSupplier: Functions.asString(json['t_supplier']));

Map<String, dynamic> _$AllSupplierToJson(AllSupplier instance) =>
    <String, dynamic>{'t_supplier': instance.tSupplier};
