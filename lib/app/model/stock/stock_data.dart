import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'stock_data.g.dart';

@JsonSerializable(explicitToJson: true)
class StockData {
  @JsonKey(name: "mPhone", fromJson: Functions.asString, toJson: Functions.stringToPhoneNumber)
  String? mPhone;
  @JsonKey(name: "mName", fromJson: Functions.asString)
  String? mName;
  @JsonKey(name: "mAddress", fromJson: Functions.asString)
  String? mAddress;
  @JsonKey(name: "mAttn", fromJson: Functions.asString)
  String? mAttn;
  @JsonKey(name: "mFax", fromJson: Functions.asString)
  String? mFax;
  @JsonKey(name: "mZip", fromJson: Functions.asString)
  String? mZip;
  @JsonKey(name: "mEmail", fromJson: Functions.asString)
  String? mEmail;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "T_Stock_ID", fromJson: Functions.asString)
  String? tStockId;
  @JsonKey(name: "mSalesMemo_Footer", fromJson: Functions.asString)
  String? mSalesMemoFooter;
  @JsonKey(name: "mSalesMemo_Remarks", fromJson: Functions.asString)
  String? mSalesMemoRemarks;
  @JsonKey(name: "mNon_Active", fromJson: Functions.asString)
  String? mNonActive;
  @JsonKey(name: "mFloorplan_PreFix", fromJson: Functions.asString)
  String? mFloorplanPreFix;
  @JsonKey(name: "mRefNo", fromJson: Functions.asString)
  String? mRefNo;
  @JsonKey(name: "mKitchenLabel", fromJson: Functions.asString)
  String? mKitchenLabel;

  StockData({
    this.mPhone,
    this.mName,
    this.mAddress,
    this.mAttn,
    this.mFax,
    this.mZip,
    this.mEmail,
    this.mRemarks,
    this.mCode,
    this.tStockId,
    this.mSalesMemoFooter,
    this.mSalesMemoRemarks,
    this.mNonActive,
    this.mFloorplanPreFix,
    this.mRefNo,
    this.mKitchenLabel,
  });

  StockData copyWith({
    String? mPhone,
    String? mName,
    String? mAddress,
    String? mAttn,
    String? mFax,
    String? mZip,
    String? mEmail,
    String? mRemarks,
    String? mCode,
    String? tStockId,
    String? mSalesMemoFooter,
    String? mSalesMemoRemarks,
    String? mNonActive,
    String? mFloorplanPreFix,
    String? mRefNo,
    String? mKitchenLabel,
  }) => StockData(
    mPhone: mPhone ?? this.mPhone,
    mName: mName ?? this.mName,
    mAddress: mAddress ?? this.mAddress,
    mAttn: mAttn ?? this.mAttn,
    mFax: mFax ?? this.mFax,
    mZip: mZip ?? this.mZip,
    mEmail: mEmail ?? this.mEmail,
    mRemarks: mRemarks ?? this.mRemarks,
    mCode: mCode ?? this.mCode,
    tStockId: tStockId ?? this.tStockId,
    mSalesMemoFooter: mSalesMemoFooter ?? this.mSalesMemoFooter,
    mSalesMemoRemarks: mSalesMemoRemarks ?? this.mSalesMemoRemarks,
    mNonActive: mNonActive ?? this.mNonActive,
    mFloorplanPreFix: mFloorplanPreFix ?? this.mFloorplanPreFix,
    mRefNo: mRefNo ?? this.mRefNo,
    mKitchenLabel: mKitchenLabel ?? this.mKitchenLabel,
  );

  factory StockData.fromJson(Map<String, dynamic> json) => _$StockDataFromJson(json);

  Map<String, dynamic> toJson() => _$StockDataToJson(this);
}
