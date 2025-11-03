import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'pay_method_data.g.dart';

@JsonSerializable()
class PayMethodData {
  @JsonKey(name: "mPayType", fromJson: Functions.asString)
  final String? mPayType;
  @JsonKey(name: "T_PayType_ID", fromJson: Functions.asString)
  final String? tPayTypeId;
  @JsonKey(name: "mSort", fromJson: Functions.asString)
  final String? mSort;
  @JsonKey(name: "mPrePaid", defaultValue: "0", fromJson: Functions.asString)
  final String? mPrePaid;
  @JsonKey(name: "mCreditCart", fromJson: Functions.asString)
  final String? mCreditCart;
  @JsonKey(name: "mCardType", defaultValue: "0", fromJson: Functions.asString)
  final String? mCardType;
  @JsonKey(name: "mCom", fromJson: Functions.asString)
  final String? mCom;
  @JsonKey(name: "mNoDrawer", defaultValue: "0", fromJson: Functions.asString)
  final String? mNoDrawer;
  @JsonKey(name: "t_paytype_online", fromJson: Functions.asString)
  final String? tPaytypeOnline;
  @JsonKey(name: "mHide", defaultValue: "0", fromJson: Functions.asString)
  final String? mHide;

  PayMethodData({
    this.mPayType,
    this.tPayTypeId,
    this.mSort,
    this.mPrePaid,
    this.mCreditCart,
    this.mCardType,
    this.mCom,
    this.mNoDrawer,
    this.tPaytypeOnline,
    this.mHide,
  });

  PayMethodData copyWith({
    String? mPayType,
    String? tPayTypeId,
    String? mSort,
    String? mPrePaid,
    String? mCreditCart,
    String? mCardType,
    String? mCom,
    String? mNoDrawer,
    String? tPaytypeOnline,
    String? mHide,
  }) => PayMethodData(
    mPayType: mPayType ?? this.mPayType,
    tPayTypeId: tPayTypeId ?? this.tPayTypeId,
    mSort: mSort ?? this.mSort,
    mPrePaid: mPrePaid ?? this.mPrePaid,
    mCreditCart: mCreditCart ?? this.mCreditCart,
    mCardType: mCardType ?? this.mCardType,
    mCom: mCom ?? this.mCom,
    mNoDrawer: mNoDrawer ?? this.mNoDrawer,
    tPaytypeOnline: tPaytypeOnline ?? this.tPaytypeOnline,
    mHide: mHide ?? this.mHide,
  );

  factory PayMethodData.fromJson(Map<String, dynamic> json) => _$PayMethodDataFromJson(json);

  Map<String, dynamic> toJson() => _$PayMethodDataToJson(this);
}
