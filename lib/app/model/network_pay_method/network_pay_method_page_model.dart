// To parse this JSON data, do
//
//     final networkPayMethodPageModel = networkPayMethodPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'network_pay_method_data.dart';

part 'network_pay_method_page_model.g.dart';

NetworkPayMethodPageModel networkPayMethodPageModelFromJson(String str) =>
    NetworkPayMethodPageModel.fromJson(json.decode(str));

String networkPayMethodPageModelToJson(NetworkPayMethodPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class NetworkPayMethodPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  NetworkPayMethodResult? apiResult;

  NetworkPayMethodPageModel({this.status, this.msg, this.apiResult});

  factory NetworkPayMethodPageModel.fromJson(Map<String, dynamic> json) => _$NetworkPayMethodPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkPayMethodPageModelToJson(this);
}

@JsonSerializable()
class NetworkPayMethodResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<NetworkPayMethodData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  NetworkPayMethodResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  factory NetworkPayMethodResult.fromJson(Map<String, dynamic> json) => _$NetworkPayMethodResultFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkPayMethodResultToJson(this);
}
