// To parse this JSON data, do
//
//     final networkPayMethodEditModel = networkPayMethodEditModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../../utils/functions.dart';
import 'network_pay_method_data.dart';

part 'network_pay_method_edit_model.g.dart';

NetworkPayMethodEditModel networkPayMethodEditModelFromJson(String str) =>
    NetworkPayMethodEditModel.fromJson(json.decode(str));

String networkPayMethodEditModelToJson(NetworkPayMethodEditModel data) => json.encode(data.toJson());

@JsonSerializable()
class NetworkPayMethodEditModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  NetworkPayMethodEditResult? apiResult;

  NetworkPayMethodEditModel({this.status, this.msg, this.apiResult});

  factory NetworkPayMethodEditModel.fromJson(Map<String, dynamic> json) => _$NetworkPayMethodEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkPayMethodEditModelToJson(this);
}

@JsonSerializable()
class NetworkPayMethodEditResult extends NetworkPayMethodData {
  @JsonKey(name: "allSupplier")
  List<AllSupplier>? allSupplier;
  @JsonKey(name: "allPayMethod")
  List<String>? allPayMethod;

  NetworkPayMethodEditResult({super.id, super.tSupplier, super.tPaytype, this.allSupplier, this.allPayMethod});

  factory NetworkPayMethodEditResult.fromJson(Map<String, dynamic> json) => _$NetworkPayMethodEditResultFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$NetworkPayMethodEditResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AllSupplier {
  @JsonKey(name: "t_supplier", fromJson: Functions.asString)
  String? tSupplier;

  AllSupplier({this.tSupplier});

  factory AllSupplier.fromJson(Map<String, dynamic> json) => _$AllSupplierFromJson(json);

  Map<String, dynamic> toJson() => _$AllSupplierToJson(this);
}
