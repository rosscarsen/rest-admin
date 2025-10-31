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
      : NetworkPayMethodData.fromJson(
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
