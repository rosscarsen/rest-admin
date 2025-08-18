// To parse this JSON data, do
//
//     final printerAllModel = printerAllModelFromJson(jsonString);

import 'dart:convert';

import 'printer_model.dart';

PrinterAllModel printerAllModelFromJson(String str) => PrinterAllModel.fromJson(json.decode(str));

String printerAllModelToJson(PrinterAllModel data) => json.encode(data.toJson());

class PrinterAllModel {
  final int? status;
  final String? msg;
  final List<PrinterModel>? apiResult;

  PrinterAllModel({this.status, this.msg, this.apiResult});

  PrinterAllModel copyWith({int? status, String? msg, List<PrinterModel>? apiResult}) =>
      PrinterAllModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory PrinterAllModel.fromJson(Map<String, dynamic> json) => PrinterAllModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null
        ? []
        : List<PrinterModel>.from(json["apiResult"]!.map((x) => PrinterModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "apiResult": apiResult == null ? [] : List<dynamic>.from(apiResult!.map((x) => x.toJson())),
  };
}
