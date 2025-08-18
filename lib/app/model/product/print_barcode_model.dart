// To parse this JSON data, do
//
//     final printBarcodeModel = printBarcodeModelFromJson(jsonString);

import 'dart:convert';

PrintBarcodeModel printBarcodeModelFromJson(String str) => PrintBarcodeModel.fromJson(json.decode(str));

String printBarcodeModelToJson(PrintBarcodeModel data) => json.encode(data.toJson());

class PrintBarcodeModel {
  int? status;
  String? msg;
  List<PrintBarcodeApiResult>? apiResult;

  PrintBarcodeModel({this.status, this.msg, this.apiResult});

  factory PrintBarcodeModel.fromJson(Map<String, dynamic> json) => PrintBarcodeModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null
        ? []
        : List<PrintBarcodeApiResult>.from(json["apiResult"]!.map((x) => PrintBarcodeApiResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "apiResult": apiResult == null ? [] : List<dynamic>.from(apiResult!.map((x) => x.toJson())),
  };
}

class PrintBarcodeApiResult {
  String? mProductCode;
  String? mCode;
  String? mName;
  int? mItem;
  String? mRemarks;
  int? tProductId;
  int? mNonActived;
  String? mPrice;

  PrintBarcodeApiResult({
    this.mProductCode,
    this.mCode,
    this.mName,
    this.mItem,
    this.mRemarks,
    this.tProductId,
    this.mNonActived,
    this.mPrice,
  });

  factory PrintBarcodeApiResult.fromJson(Map<String, dynamic> json) => PrintBarcodeApiResult(
    mProductCode: json["mProduct_Code"],
    mCode: json["mCode"],
    mName: json["mName"],
    mItem: json["mItem"],
    mRemarks: json["mRemarks"],
    tProductId: json["T_Product_ID"],
    mNonActived: json["mNonActived"],
    mPrice: json["mPrice"],
  );

  Map<String, dynamic> toJson() => {
    "mProduct_Code": mProductCode,
    "mCode": mCode,
    "mName": mName,
    "mItem": mItem,
    "mRemarks": mRemarks,
    "T_Product_ID": tProductId,
    "mNonActived": mNonActived,
    "mPrice": mPrice,
  };
}
