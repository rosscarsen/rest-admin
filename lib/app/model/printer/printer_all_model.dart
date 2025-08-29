// To parse this JSON data, do
//
//     final printerAllModel = printerAllModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'printer_data.dart';

part 'printer_all_model.g.dart';

PrinterAllModel printerAllModelFromJson(String str) => PrinterAllModel.fromJson(json.decode(str));

String printerAllModelToJson(PrinterAllModel data) => json.encode(data.toJson());

@JsonSerializable()
class PrinterAllModel {
  @JsonKey(name: "status")
  final int? status;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "apiResult")
  final List<PrinterData>? apiResult;

  PrinterAllModel({this.status, this.msg, this.apiResult});

  PrinterAllModel copyWith({int? status, String? msg, List<PrinterData>? apiResult}) =>
      PrinterAllModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory PrinterAllModel.fromJson(Map<String, dynamic> json) => _$PrinterAllModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterAllModelToJson(this);
}
