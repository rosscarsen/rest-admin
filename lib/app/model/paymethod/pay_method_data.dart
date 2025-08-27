import 'package:json_annotation/json_annotation.dart';
part 'pay_method_data.g.dart';

@JsonSerializable()
class PayMethodData {
  @JsonKey(name: "mPayType")
  final String? mPayType;
  @JsonKey(name: "T_PayType_ID")
  final int? tPayTypeId;
  @JsonKey(name: "mSort")
  final int? mSort;
  @JsonKey(name: "mPrePaid", defaultValue: 0)
  final int? mPrePaid;
  @JsonKey(name: "mCreditCart")
  final int? mCreditCart;
  @JsonKey(name: "mCardType", defaultValue: 0)
  final int? mCardType;
  @JsonKey(name: "mCom")
  final String? mCom;
  @JsonKey(name: "mNoDrawer", defaultValue: 0)
  final int? mNoDrawer;
  @JsonKey(name: "t_paytype_online")
  final String? tPaytypeOnline;
  @JsonKey(name: "mHide", defaultValue: 0)
  final int? mHide;

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
    int? tPayTypeId,
    int? mSort,
    int? mPrePaid,
    int? mCreditCart,
    int? mCardType,
    String? mCom,
    int? mNoDrawer,
    String? tPaytypeOnline,
    int? mHide,
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
