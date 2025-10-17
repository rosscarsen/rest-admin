// To parse this JSON data, do
//
//     final setMealPageModel = setMealPageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'set_meal_data.dart';

part 'set_meal_page_model.g.dart';

SetMealPageModel setMealPageModelFromJson(String str) => SetMealPageModel.fromJson(json.decode(str));

String setMealPageModelToJson(SetMealPageModel data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class SetMealPageModel {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "apiResult")
  SetMealResult? apiResult;

  SetMealPageModel({this.status, this.msg, this.apiResult});

  SetMealPageModel copyWith({int? status, String? msg, SetMealResult? apiResult}) =>
      SetMealPageModel(status: status ?? this.status, msg: msg ?? this.msg, apiResult: apiResult ?? this.apiResult);

  factory SetMealPageModel.fromJson(Map<String, dynamic> json) => _$SetMealPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SetMealPageModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetMealResult {
  @JsonKey(name: "total")
  int? total;
  @JsonKey(name: "per_page")
  int? perPage;
  @JsonKey(name: "current_page")
  int? currentPage;
  @JsonKey(name: "last_page")
  int? lastPage;
  @JsonKey(name: "data")
  List<SetMealData>? data;
  @JsonKey(name: "has_more")
  bool? hasMore;

  SetMealResult({this.total, this.perPage, this.currentPage, this.lastPage, this.data, this.hasMore});

  SetMealResult copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
    List<SetMealData>? data,
    bool? hasMore,
  }) => SetMealResult(
    total: total ?? this.total,
    perPage: perPage ?? this.perPage,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    data: data ?? this.data,
    hasMore: hasMore ?? this.hasMore,
  );

  factory SetMealResult.fromJson(Map<String, dynamic> json) => _$SetMealResultFromJson(json);

  Map<String, dynamic> toJson() => _$SetMealResultToJson(this);
}
