// To parse this JSON data, do
//
//     final tablesPageModel = tablesPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import '../stock/stock_data.dart';
import 'tables_data.dart';

part 'tables_page_model.g.dart';

TablesPageModel tablesPageModelFromJson(String str) => TablesPageModel.fromJson(json.decode(str));

String tablesPageModelToJson(TablesPageModel data) => json.encode(data.toJson());

@JsonSerializable()
class TablesPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  TablesResult? apiResult;

  TablesPageModel({this.status, this.msg, this.apiResult});

  factory TablesPageModel.fromJson(Map<String, dynamic> json) => _$TablesPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$TablesPageModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TablesResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<TablesData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;
  @JsonKey(name: "allStock")
  List<StockData>? allStock;

  TablesResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore, this.allStock});

  factory TablesResult.fromJson(Map<String, dynamic> json) => _$TablesResultFromJson(json);

  Map<String, dynamic> toJson() => _$TablesResultToJson(this);
}
