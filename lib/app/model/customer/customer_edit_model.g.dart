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
  invoiceAmount: Functions.formatAmount(json['invoiceAmount']),
  customerPoint: Functions.formatAmount(json['customerPoint']),
  currency: (json['currency'] as List<dynamic>?)
      ?.map((e) => CurrencyData.fromJson(e as Map<String, dynamic>))
      .toList(),
  customerDiscount: (json['customerDiscount'] as List<dynamic>?)
      ?.map((e) => CustomerDiscount.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ApiResultToJson(ApiResult instance) => <String, dynamic>{
  'customerInfo': instance.customerInfo?.toJson(),
  'customerType': instance.customerType,
  'customerContact': instance.customerContact?.map((e) => e.toJson()).toList(),
  'invoiceAmount': instance.invoiceAmount,
  'customerPoint': instance.customerPoint,
  'currency': instance.currency?.map((e) => e.toJson()).toList(),
  'customerDiscount': instance.customerDiscount
      ?.map((e) => e.toJson())
      .toList(),
};

CustomerDiscount _$CustomerDiscountFromJson(Map<String, dynamic> json) =>
    CustomerDiscount(
      tCustomerId: Functions.asString(json['t_customer_id']),
      mItem: Functions.asString(json['mItem']),
      mCategory: Functions.asString(json['mCategory']),
      mDiscount: Functions.asString(json['mDiscount']),
      mExpiryDate: Functions.asString(json['mExpiry_Date']),
      mNonActive: Functions.asString(json['mNon_Active']),
    );

Map<String, dynamic> _$CustomerDiscountToJson(CustomerDiscount instance) =>
    <String, dynamic>{
      't_customer_id': instance.tCustomerId,
      'mItem': instance.mItem,
      'mCategory': instance.mCategory,
      'mDiscount': instance.mDiscount,
      'mExpiry_Date': instance.mExpiryDate,
      'mNon_Active': instance.mNonActive,
    };
