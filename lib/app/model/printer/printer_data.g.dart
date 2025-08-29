// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterData _$PrinterDataFromJson(Map<String, dynamic> json) => PrinterData(
  mItem: Functions.asString(json['mItem']),
  mName: Functions.asString(json['mName']),
  mDeviceName: Functions.asString(json['mDeviceName']),
  mNetworkPrint: Functions.asString(json['mNetworkPrint']),
  mRemarks: Functions.asString(json['mRemarks']),
  mLanIp: Functions.asString(json['mLanIP']),
  mPrinterType: Functions.asString(json['mPrinterType']),
  mBackupPrinter: Functions.asString(json['mBackupPrinter']),
  mBackupPrinter1: Functions.asString(json['mBackupPrinter1']),
  mBackupPrinter2: Functions.asString(json['mBackupPrinter2']),
);

Map<String, dynamic> _$PrinterDataToJson(PrinterData instance) =>
    <String, dynamic>{
      'mItem': instance.mItem,
      'mName': instance.mName,
      'mDeviceName': instance.mDeviceName,
      'mNetworkPrint': instance.mNetworkPrint,
      'mRemarks': instance.mRemarks,
      'mLanIP': instance.mLanIp,
      'mPrinterType': instance.mPrinterType,
      'mBackupPrinter': instance.mBackupPrinter,
      'mBackupPrinter1': instance.mBackupPrinter1,
      'mBackupPrinter2': instance.mBackupPrinter2,
    };
