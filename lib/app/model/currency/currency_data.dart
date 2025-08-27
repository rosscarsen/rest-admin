import 'package:json_annotation/json_annotation.dart';
part 'currency_data.g.dart';

@JsonSerializable()
class CurrencyData {
  @JsonKey(name: "mDescription")
  final String? mDescription;
  @JsonKey(name: "mCode")
  final String? mCode;
  @JsonKey(name: "mRate")
  final String? mRate;
  @JsonKey(name: "mDefault", defaultValue: 0)
  final int? mDefault;
  @JsonKey(name: "T_MoneyCurrency_ID")
  final int? tMoneyCurrencyId;

  CurrencyData({this.mDescription, this.mCode, this.mRate, this.mDefault, this.tMoneyCurrencyId});

  CurrencyData copyWith({String? mDescription, String? mCode, String? mRate, int? mDefault, int? tMoneyCurrencyId}) =>
      CurrencyData(
        mDescription: mDescription ?? this.mDescription,
        mCode: mCode ?? this.mCode,
        mRate: mRate ?? this.mRate,
        mDefault: mDefault ?? this.mDefault,
        tMoneyCurrencyId: tMoneyCurrencyId ?? this.tMoneyCurrencyId,
      );

  factory CurrencyData.fromJson(Map<String, dynamic> json) => _$CurrencyDataFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyDataToJson(this);
}
