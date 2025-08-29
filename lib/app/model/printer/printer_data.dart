import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'printer_data.g.dart';

@JsonSerializable()
class PrinterData {
  @JsonKey(name: "mItem", fromJson: Functions.asString)
  final String? mItem;
  @JsonKey(name: "mName", fromJson: Functions.asString)
  final String? mName;
  @JsonKey(name: "mDeviceName", fromJson: Functions.asString)
  final String? mDeviceName;
  @JsonKey(name: "mNetworkPrint", fromJson: Functions.asString)
  final String? mNetworkPrint;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  final String? mRemarks;
  @JsonKey(name: "mLanIP", fromJson: Functions.asString)
  final String? mLanIp;
  @JsonKey(name: "mPrinterType", fromJson: Functions.asString)
  final String? mPrinterType;
  @JsonKey(name: "mBackupPrinter", fromJson: Functions.asString)
  final String? mBackupPrinter;
  @JsonKey(name: "mBackupPrinter1", fromJson: Functions.asString)
  final String? mBackupPrinter1;
  @JsonKey(name: "mBackupPrinter2", fromJson: Functions.asString)
  final String? mBackupPrinter2;

  PrinterData({
    this.mItem,
    this.mName,
    this.mDeviceName,
    this.mNetworkPrint,
    this.mRemarks,
    this.mLanIp,
    this.mPrinterType,
    this.mBackupPrinter,
    this.mBackupPrinter1,
    this.mBackupPrinter2,
  });

  PrinterData copyWith({
    String? mItem,
    String? mName,
    String? mDeviceName,
    String? mNetworkPrint,
    String? mRemarks,
    String? mLanIp,
    String? mPrinterType,
    String? mBackupPrinter,
    String? mBackupPrinter1,
    String? mBackupPrinter2,
  }) => PrinterData(
    mItem: mItem ?? this.mItem,
    mName: mName ?? this.mName,
    mDeviceName: mDeviceName ?? this.mDeviceName,
    mNetworkPrint: mNetworkPrint ?? this.mNetworkPrint,
    mRemarks: mRemarks ?? this.mRemarks,
    mLanIp: mLanIp ?? this.mLanIp,
    mPrinterType: mPrinterType ?? this.mPrinterType,
    mBackupPrinter: mBackupPrinter ?? this.mBackupPrinter,
    mBackupPrinter1: mBackupPrinter1 ?? this.mBackupPrinter1,
    mBackupPrinter2: mBackupPrinter2 ?? this.mBackupPrinter2,
  );

  factory PrinterData.fromJson(Map<String, dynamic> json) => _$PrinterDataFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterDataToJson(this);
}
