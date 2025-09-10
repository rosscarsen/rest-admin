// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerEditModel _$CustomerEditModelFromJson(Map<String, dynamic> json) =>
    CustomerEditModel(
      status: (json['status'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      apiResult: json['apiResult'] == null
          ? null
          : ApiResult.fromJson(json['apiResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerEditModelToJson(CustomerEditModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult?.toJson(),
    };

ApiResult _$ApiResultFromJson(Map<String, dynamic> json) => ApiResult(
  customerInfo: json['customerInfo'] == null
      ? null
      : CustomerData.fromJson(json['customerInfo'] as Map<String, dynamic>),
  customerType: (json['customerType'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  customerContact: (json['customerContact'] as List<dynamic>?)
      ?.map((e) => CustomerContact.fromJson(e as Map<String, dynamic>))
      .toList(),
  invoiceAmount: json['invoiceAmount'] as String?,
  customerPoint: json['customerPoint'] as String?,
  currency: (json['currency'] as List<dynamic>?)
      ?.map((e) => CurrencyData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ApiResultToJson(ApiResult instance) => <String, dynamic>{
  'customerInfo': instance.customerInfo?.toJson(),
  'customerType': instance.customerType,
  'customerContact': instance.customerContact?.map((e) => e.toJson()).toList(),
  'invoiceAmount': instance.invoiceAmount,
  'customerPoint': instance.customerPoint,
  'currency': instance.currency?.map((e) => e.toJson()).toList(),
};
