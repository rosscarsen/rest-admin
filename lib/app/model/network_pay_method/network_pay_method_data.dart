import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'network_pay_method_data.g.dart';

@JsonSerializable(explicitToJson: true)
class NetworkPayMethodData {
  @JsonKey(name: "id", fromJson: Functions.asString)
  String? id;
  @JsonKey(name: "t_supplier", fromJson: Functions.asString)
  String? tSupplier;
  @JsonKey(name: "t_paytype", fromJson: Functions.asString)
  String? tPaytype;

  NetworkPayMethodData({this.id, this.tSupplier, this.tPaytype});

  factory NetworkPayMethodData.fromJson(Map<String, dynamic> json) => _$NetworkPayMethodDataFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkPayMethodDataToJson(this);
}
