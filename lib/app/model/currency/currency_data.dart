import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'currency_data.g.dart';

@JsonSerializable()
class CurrencyData {
  @JsonKey(name: "mDescription", fromJson: Functions.asString)
  String? mDescription;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "mRate", fromJson: Functions.asString)
  String? mRate;
  @JsonKey(name: "mDefault", defaultValue: "0", fromJson: Functions.asString)
  String? mDefault;
  @JsonKey(name: "T_MoneyCurrency_ID", fromJson: Functions.asString)
  String? tMoneyCurrencyId;

  CurrencyData({this.mDescription, this.mCode, this.mRate, this.mDefault, this.tMoneyCurrencyId});

  CurrencyData copyWith({
    String? mDescription,
    String? mCode,
    String? mRate,
    String? mDefault,
    String? tMoneyCurrencyId,
  }) => CurrencyData(
    mDescription: mDescription ?? this.mDescription,
    mCode: mCode ?? this.mCode,
    mRate: mRate ?? this.mRate,
    mDefault: mDefault ?? this.mDefault,
    tMoneyCurrencyId: tMoneyCurrencyId ?? this.tMoneyCurrencyId,
  );

  factory CurrencyData.fromJson(Map<String, dynamic> json) => _$CurrencyDataFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyDataToJson(this);
}
