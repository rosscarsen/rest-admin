// To parse this JSON data, do
//
//     final printBarcodeModel = printBarcodeModelFromJson(jsonString);

import 'dart:convert';

PrintBarcodeModel printBarcodeModelFromJson(String str) => PrintBarcodeModel.fromJson(json.decode(str));

String printBarcodeModelToJson(PrintBarcodeModel data) => json.encode(data.toJson());

class PrintBarcodeModel {
  List<PrintbarcodeResult>? result;
  String? msg;
  int? status;

  PrintBarcodeModel({this.result, this.msg, this.status});

  factory PrintBarcodeModel.fromJson(Map<String, dynamic> json) => PrintBarcodeModel(
    result:
        json["result"] == null
            ? []
            : List<PrintbarcodeResult>.from(json["result"]!.map((x) => PrintbarcodeResult.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class PrintbarcodeResult {
  String? mProductCode;
  String? mCode;
  String? mName;
  int? mItem;
  String? mRemarks;
  int? tProductId;
  int? mNonActived;
  String? mPrice;

  PrintbarcodeResult({
    this.mProductCode,
    this.mCode,
    this.mName,
    this.mItem,
    this.mRemarks,
    this.tProductId,
    this.mNonActived,
    this.mPrice,
  });

  factory PrintbarcodeResult.fromJson(Map<String, dynamic> json) => PrintbarcodeResult(
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
