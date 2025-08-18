class PrinterModel {
  final int? mItem;
  final String? mName;
  final String? mDeviceName;
  final String? mNetworkPrint;
  final String? mRemarks;
  final String? mLanIp;
  final String? mPrinterType;
  final String? mBackupPrinter;
  final String? mBackupPrinter1;
  final String? mBackupPrinter2;

  PrinterModel({
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

  PrinterModel copyWith({
    int? mItem,
    String? mName,
    String? mDeviceName,
    String? mNetworkPrint,
    String? mRemarks,
    String? mLanIp,
    String? mPrinterType,
    String? mBackupPrinter,
    String? mBackupPrinter1,
    String? mBackupPrinter2,
  }) => PrinterModel(
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

  factory PrinterModel.fromJson(Map<String, dynamic> json) => PrinterModel(
    mItem: json["mItem"],
    mName: json["mName"],
    mDeviceName: json["mDeviceName"],
    mNetworkPrint: json["mNetworkPrint"],
    mRemarks: json["mRemarks"],
    mLanIp: json["mLanIP"],
    mPrinterType: json["mPrinterType"],
    mBackupPrinter: json["mBackupPrinter"],
    mBackupPrinter1: json["mBackupPrinter1"],
    mBackupPrinter2: json["mBackupPrinter2"],
  );

  Map<String, dynamic> toJson() => {
    "mItem": mItem,
    "mName": mName,
    "mDeviceName": mDeviceName,
    "mNetworkPrint": mNetworkPrint,
    "mRemarks": mRemarks,
    "mLanIP": mLanIp,
    "mPrinterType": mPrinterType,
    "mBackupPrinter": mBackupPrinter,
    "mBackupPrinter1": mBackupPrinter1,
    "mBackupPrinter2": mBackupPrinter2,
  };
}
