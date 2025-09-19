// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final chartModel = chartModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

ChartModel chartModelFromJson(String str) => ChartModel.fromJson(json.decode(str));

String chartModelToJson(ChartModel data) => json.encode(data.toJson());

class ChartModel {
  int? status;
  String? msg;
  ChartResult? apiResult;

  ChartModel({this.status, this.msg, this.apiResult});

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
    status: json["status"],
    msg: json["msg"],
    apiResult: json["apiResult"] == null ? null : ChartResult.fromJson(json["apiResult"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "apiResult": apiResult?.toJson()};
}

class ChartResult {
  List<SalePlayRatio>? salePlayRatio;
  List<SevenSale>? sevenSale;
  ThreeRatio? threeRatio;
  List<MonthEverySale>? monthEverySale;
  List<TopSaleQty>? topSaleQty;
  List<TopSaleAmount>? topSaleAmount;

  ChartResult({
    this.salePlayRatio,
    this.sevenSale,
    this.threeRatio,
    this.monthEverySale,
    this.topSaleQty,
    this.topSaleAmount,
  });

  factory ChartResult.fromJson(Map<String, dynamic> json) => ChartResult(
    salePlayRatio: json["salePlayRatio"] == null
        ? []
        : List<SalePlayRatio>.from(json["salePlayRatio"]!.map((x) => SalePlayRatio.fromJson(x))),
    sevenSale: json["sevenSale"] == null
        ? []
        : List<SevenSale>.from(json["sevenSale"]!.map((x) => SevenSale.fromJson(x))),
    threeRatio: json["threeRatio"] == null ? null : ThreeRatio.fromJson(json["threeRatio"]),
    monthEverySale: json["monthEverySale"] == null
        ? []
        : List<MonthEverySale>.from(json["monthEverySale"]!.map((x) => MonthEverySale.fromJson(x))),
    topSaleQty: json["topSaleQty"] == null
        ? []
        : List<TopSaleQty>.from(json["topSaleQty"]!.map((x) => TopSaleQty.fromJson(x))),
    topSaleAmount: json["topSaleAmount"] == null
        ? []
        : List<TopSaleAmount>.from(json["topSaleAmount"]!.map((x) => TopSaleAmount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "salePlayRatio": salePlayRatio == null ? [] : List<dynamic>.from(salePlayRatio!.map((x) => x.toJson())),
    "sevenSale": sevenSale == null ? [] : List<dynamic>.from(sevenSale!.map((x) => x.toJson())),
    "threeRatio": threeRatio?.toJson(),
    "monthEverySale": monthEverySale == null ? [] : List<dynamic>.from(monthEverySale!.map((x) => x.toJson())),
    "topSaleQty": topSaleQty == null ? [] : List<dynamic>.from(topSaleQty!.map((x) => x.toJson())),
    "topSaleAmount": topSaleAmount == null ? [] : List<dynamic>.from(topSaleAmount!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ApiResult(salePlayRatio: $salePlayRatio, sevenSale: $sevenSale, threeRatio: $threeRatio, monthEverySale: $monthEverySale, topSaleQty: $topSaleQty, topSaleAmount: $topSaleAmount)';
  }
}

class MonthEverySale {
  DateTime? dayLabel;
  String? totalAmount;
  String? formatDate;

  MonthEverySale({this.dayLabel, this.totalAmount, this.formatDate});

  factory MonthEverySale.fromJson(Map<String, dynamic> json) => MonthEverySale(
    dayLabel: json["dayLabel"] == null ? null : DateTime.parse(json["dayLabel"]),
    totalAmount: json["totalAmount"],
    formatDate: json["formatDate"],
  );

  Map<String, dynamic> toJson() => {
    "dayLabel":
        "${dayLabel!.year.toString().padLeft(4, '0')}-${dayLabel!.month.toString().padLeft(2, '0')}-${dayLabel!.day.toString().padLeft(2, '0')}",
    "totalAmount": totalAmount,
    "formatDate": formatDate,
  };

  @override
  String toString() => 'MonthEverySale(dayLabel: $dayLabel, totalAmount: $totalAmount, formatDate: $formatDate)';
}

class SalePlayRatio {
  String? mPayType;
  String? totalAmount;
  final Color color; // 不用 late，更安全

  SalePlayRatio({this.mPayType, this.totalAmount, Color? color}) : color = color ?? AppColors.genRandomColor();

  factory SalePlayRatio.fromJson(Map<String, dynamic> json) {
    return SalePlayRatio(mPayType: json["mPayType"], totalAmount: json["totalAmount"]);
  }

  Map<String, dynamic> toJson() => {"mPayType": mPayType, "totalAmount": totalAmount};

  @override
  String toString() => 'SalePlayRatio(mPayType: $mPayType, totalAmount: $totalAmount, color: $color)';
}

class SevenSale {
  DateTime? invoiceDate;
  String? totalAmount;

  SevenSale({this.invoiceDate, this.totalAmount});

  factory SevenSale.fromJson(Map<String, dynamic> json) => SevenSale(
    invoiceDate: json["invoiceDate"] == null ? null : DateTime.parse(json["invoiceDate"]),
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "invoiceDate":
        "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
    "totalAmount": totalAmount,
  };

  @override
  String toString() => 'SevenSale(invoiceDate: $invoiceDate, totalAmount: $totalAmount)';
}

class ThreeRatio {
  List<DayResult>? dayResult;
  List<WeekResult>? weekResult;
  List<MonthResult>? monthResult;

  ThreeRatio({this.dayResult, this.weekResult, this.monthResult});

  factory ThreeRatio.fromJson(Map<String, dynamic> json) => ThreeRatio(
    dayResult: json["dayResult"] == null
        ? []
        : List<DayResult>.from(json["dayResult"]!.map((x) => DayResult.fromJson(x))),
    weekResult: json["weekResult"] == null
        ? []
        : List<WeekResult>.from(json["weekResult"]!.map((x) => WeekResult.fromJson(x))),
    monthResult: json["monthResult"] == null
        ? []
        : List<MonthResult>.from(json["monthResult"]!.map((x) => MonthResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dayResult": dayResult == null ? [] : List<dynamic>.from(dayResult!.map((x) => x.toJson())),
    "weekResult": weekResult == null ? [] : List<dynamic>.from(weekResult!.map((x) => x.toJson())),
    "monthResult": monthResult == null ? [] : List<dynamic>.from(monthResult!.map((x) => x.toJson())),
  };

  @override
  String toString() => 'ThreeRatio(dayResult: $dayResult, weekResult: $weekResult, monthResult: $monthResult)';
}

class DayResult {
  DateTime? invoiceDate;
  String? totalAmount;
  String? growthRate;

  DayResult({this.invoiceDate, this.totalAmount, this.growthRate});

  factory DayResult.fromJson(Map<String, dynamic> json) => DayResult(
    invoiceDate: json["invoiceDate"] == null ? null : DateTime.parse(json["invoiceDate"]),
    totalAmount: json["totalAmount"],
    growthRate: json["growthRate"],
  );

  Map<String, dynamic> toJson() => {
    "invoiceDate":
        "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
    "totalAmount": totalAmount,
    "growthRate": growthRate,
  };

  @override
  String toString() => 'DayResult(invoiceDate: $invoiceDate, totalAmount: $totalAmount, growthRate: $growthRate)';
}

class MonthResult {
  String? invoiceMonth;
  String? totalAmount;
  String? growthRate;

  MonthResult({this.invoiceMonth, this.totalAmount, this.growthRate});

  factory MonthResult.fromJson(Map<String, dynamic> json) =>
      MonthResult(invoiceMonth: json["invoiceMonth"], totalAmount: json["totalAmount"], growthRate: json["growthRate"]);

  Map<String, dynamic> toJson() => {"invoiceMonth": invoiceMonth, "totalAmount": totalAmount, "growthRate": growthRate};

  @override
  String toString() => 'MonthResult(invoiceMonth: $invoiceMonth, totalAmount: $totalAmount, growthRate: $growthRate)';
}

class WeekResult {
  String? invoiceWeek;
  String? totalAmount;
  String? growthRate;

  WeekResult({this.invoiceWeek, this.totalAmount, this.growthRate});

  factory WeekResult.fromJson(Map<String, dynamic> json) =>
      WeekResult(invoiceWeek: json["invoiceWeek"], totalAmount: json["totalAmount"], growthRate: json["growthRate"]);

  Map<String, dynamic> toJson() => {"invoiceWeek": invoiceWeek, "totalAmount": totalAmount, "growthRate": growthRate};
}

class TopSaleAmount {
  String? mCode;
  String? mDesc1;
  String? mAmount;
  String? mSQty;
  String? mPrice;
  String? qty;

  TopSaleAmount({this.mCode, this.mDesc1, this.mAmount, this.mSQty, this.mPrice, this.qty});

  factory TopSaleAmount.fromJson(Map<String, dynamic> json) => TopSaleAmount(
    mCode: json["mCode"],
    mDesc1: json["mDesc1"],
    mAmount: json["mAmount"],
    mSQty: json["mSQty"],
    mPrice: json["mPrice"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "mCode": mCode,
    "mDesc1": mDesc1,
    "mAmount": mAmount,
    "mSQty": mSQty,
    "mPrice": mPrice,
    "qty": qty,
  };

  @override
  String toString() {
    return 'TopSaleAmount(mCode: $mCode, mDesc1: $mDesc1, mAmount: $mAmount, mSQty: $mSQty, mPrice: $mPrice, qty: $qty)';
  }
}

class TopSaleQty {
  String? mCode;
  String? mDesc1;
  String? mQty;
  String? mSQty;
  String? mPrice;

  TopSaleQty({this.mCode, this.mDesc1, this.mQty, this.mSQty, this.mPrice});

  factory TopSaleQty.fromJson(Map<String, dynamic> json) => TopSaleQty(
    mCode: json["mCode"],
    mDesc1: json["mDesc1"],
    mQty: json["mQty"],
    mSQty: json["mSQty"],
    mPrice: json["mPrice"],
  );

  Map<String, dynamic> toJson() => {"mCode": mCode, "mDesc1": mDesc1, "mQty": mQty, "mSQty": mSQty, "mPrice": mPrice};

  @override
  String toString() {
    return 'TopSaleQty(mCode: $mCode, mDesc1: $mDesc1, mQty: $mQty, mSQty: $mSQty, mPrice: $mPrice)';
  }
}
