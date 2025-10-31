// To parse this JSON data, do
//
//     final payMethodEditModel = payMethodEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../utils/functions.dart';
import '../network_pay_method/network_pay_method_data.dart';
import 'pay_method_data.dart';

part 'pay_method_edit_model.g.dart';

PayMethodEditModel payMethodEditModelFromJson(String str) => PayMethodEditModel.fromJson(json.decode(str));

String payMethodEditModelToJson(PayMethodEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class PayMethodEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  PayMethodEditResult? apiResult;

  PayMethodEditModel({this.status, this.msg, this.apiResult});

  factory PayMethodEditModel.fromJson(Map<String, dynamic> json) => _$PayMethodEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayMethodEditModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PayMethodEditResult extends PayMethodData {
  @JsonKey(name: "networkPayMethod")
  List<NetworkPayMethodData>? networkPayMethod;
  PayMethodEditResult({
    super.mPayType,
    super.tPayTypeId,
    super.mSort,
    super.mPrePaid,
    super.mCreditCart,
    super.mCardType,
    super.mCom,
    super.mNoDrawer,
    super.tPaytypeOnline,
    super.mHide,
    this.networkPayMethod,
  });

  factory PayMethodEditResult.fromJson(Map<String, dynamic> json) => _$PayMethodEditResultFromJson(json);

  Map<String, dynamic> toJson() => _$PayMethodEditResultToJson(this);
}
