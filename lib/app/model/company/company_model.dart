import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'company_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Company {
  @JsonKey(name: "mName_Chinese", fromJson: Functions.asString)
  String? mNameChinese;
  @JsonKey(name: "mTel", fromJson: Functions.asString)
  String? mTel;
  @JsonKey(name: "mFax", fromJson: Functions.asString)
  String? mFax;
  @JsonKey(name: "mAddress", fromJson: Functions.asString)
  String? mAddress;
  @JsonKey(name: "mEMail", fromJson: Functions.asString)
  String? mEMail;
  @JsonKey(name: "mLogoPath", fromJson: Functions.asString)
  String? mLogoPath;
  @JsonKey(name: "mWebSite", fromJson: Functions.asString)
  String? mWebSite;
  @JsonKey(name: "mName_English", fromJson: Functions.asString)
  String? mNameEnglish;
  @JsonKey(name: "T_Company_ID", fromJson: Functions.asString)
  String? tCompanyId;
  @JsonKey(name: "mStock_Adjustment_In_PreFix", fromJson: Functions.asString)
  String? mStockAdjustmentInPreFix;
  @JsonKey(name: "mStock_Adjustment_In_SubFix", fromJson: Functions.asString)
  String? mStockAdjustmentInSubFix;
  @JsonKey(name: "mInit_Stock_Adjustment_In_No", fromJson: Functions.asString)
  String? mInitStockAdjustmentInNo;
  @JsonKey(name: "mStock_Internal_PreFix", fromJson: Functions.asString)
  String? mStockInternalPreFix;
  @JsonKey(name: "mStock_Internal_SubFix", fromJson: Functions.asString)
  String? mStockInternalSubFix;
  @JsonKey(name: "mInit_Stock_Internal_No", fromJson: Functions.asString)
  String? mInitStockInternalNo;
  @JsonKey(name: "mSupplier_Invoice_In_PreFix", fromJson: Functions.asString)
  String? mSupplierInvoiceInPreFix;
  @JsonKey(name: "mSupplier_Invoice_In_SubFix", fromJson: Functions.asString)
  String? mSupplierInvoiceInSubFix;
  @JsonKey(name: "mInit_Supplier_Invoice_In_No", fromJson: Functions.asString)
  String? mInitSupplierInvoiceInNo;
  @JsonKey(name: "mStock_Adjustment_Out_PreFix", fromJson: Functions.asString)
  String? mStockAdjustmentOutPreFix;
  @JsonKey(name: "mStock_Adjustment_Out_SubFix", fromJson: Functions.asString)
  String? mStockAdjustmentOutSubFix;
  @JsonKey(name: "mInit_Stock_Adjustment_Out_No", fromJson: Functions.asString)
  String? mInitStockAdjustmentOutNo;
  @JsonKey(name: "mConsignment_In_PreFix", fromJson: Functions.asString)
  String? mConsignmentInPreFix;
  @JsonKey(name: "mConsignment_In_SubFix", fromJson: Functions.asString)
  String? mConsignmentInSubFix;
  @JsonKey(name: "mInit_Consignment_In_No", fromJson: Functions.asString)
  String? mInitConsignmentInNo;
  @JsonKey(name: "mConsignment_Out_PreFix", fromJson: Functions.asString)
  String? mConsignmentOutPreFix;
  @JsonKey(name: "mConsignment_Out_SubFix", fromJson: Functions.asString)
  String? mConsignmentOutSubFix;
  @JsonKey(name: "mInit_Consignment_Out_No", fromJson: Functions.asString)
  String? mInitConsignmentOutNo;
  @JsonKey(name: "mTrading_Invoice_PreFix", fromJson: Functions.asString)
  String? mTradingInvoicePreFix;
  @JsonKey(name: "mTrading_Invoice_SubFix", fromJson: Functions.asString)
  String? mTradingInvoiceSubFix;
  @JsonKey(name: "mInit_Trading_Invoice_No", fromJson: Functions.asString)
  String? mInitTradingInvoiceNo;
  @JsonKey(name: "mCustomer_PreFix", fromJson: Functions.asString)
  String? mCustomerPreFix;
  @JsonKey(name: "mCustomer_SubFix", fromJson: Functions.asString)
  String? mCustomerSubFix;
  @JsonKey(name: "mUpdate_URL", fromJson: Functions.asString)
  String? mUpdateUrl;
  @JsonKey(name: "mUpdate_Version", fromJson: Functions.asString)
  String? mUpdateVersion;
  @JsonKey(name: "mDefault_Customer", fromJson: Functions.asString)
  String? mDefaultCustomer;
  @JsonKey(name: "mTrading_Invoice_Terms", fromJson: Functions.asString)
  String? mTradingInvoiceTerms;
  @JsonKey(name: "mSupplier_Invoice_Terms", fromJson: Functions.asString)
  String? mSupplierInvoiceTerms;
  @JsonKey(name: "mExtend", fromJson: Functions.asString)
  String? mExtend;
  @JsonKey(name: "mFtp_Server, fromJson: Functions.asString")
  String? mFtpServer;
  @JsonKey(name: "mFtp_User", fromJson: Functions.asString)
  String? mFtpUser;
  @JsonKey(name: "mFtp_Password", fromJson: Functions.asString)
  String? mFtpPassword;
  @JsonKey(name: "mAR_CREDIt_code", fromJson: Functions.asString)
  String? mArCredItCode;
  @JsonKey(name: "mAP_DEBIt_code", fromJson: Functions.asString)
  String? mApDebItCode;
  @JsonKey(name: "mElectronic_Ordering_PreFix", fromJson: Functions.asString)
  String? mElectronicOrderingPreFix;
  @JsonKey(name: "mElectronic_Ordering_SubFix", fromJson: Functions.asString)
  String? mElectronicOrderingSubFix;
  @JsonKey(name: "mInit_electronic_ordering_no", fromJson: Functions.asString)
  String? mInitElectronicOrderingNo;
  @JsonKey(name: "mQRUrl", fromJson: Functions.asString)
  String? mQrUrl;
  @JsonKey(name: "cloudPrintUser", fromJson: Functions.asString)
  String? cloudPrintUser;
  @JsonKey(name: "cloudPrintKey", fromJson: Functions.asString)
  String? cloudPrintKey;
  @JsonKey(name: "invoicePrinter", fromJson: Functions.asString)
  String? invoicePrinter;
  @JsonKey(name: "upperMenuPrinter", fromJson: Functions.asString)
  String? upperMenuPrinter;
  @JsonKey(name: "isPrintPrice", fromJson: Functions.asString)
  String? isPrintPrice;
  @JsonKey(name: "mTakeaway_Information", fromJson: Functions.asString)
  String? mTakeawayInformation;
  @JsonKey(name: "mFtp_list", fromJson: Functions.asString)
  String? mFtpList;
  @JsonKey(name: "mKiosk2", fromJson: Functions.asString)
  String? mKiosk2;
  @JsonKey(name: "mKiosk3", fromJson: Functions.asString)
  String? mKiosk3;
  @JsonKey(name: "isCloudPrinter", fromJson: Functions.asString)
  String? isCloudPrinter;
  @JsonKey(name: "atuo_food_list", fromJson: Functions.asString)
  String? atuoFoodList;
  @JsonKey(name: "takeaway_printer", fromJson: Functions.asString)
  String? takeawayPrinter;
  @JsonKey(name: "ta_auto_print", fromJson: Functions.asString)
  String? taAutoPrint;
  @JsonKey(name: "mNotify", fromJson: Functions.asString)
  String? mNotify;
  @JsonKey(name: "mTableDisplay", fromJson: Functions.asString)
  String? mTableDisplay;
  @JsonKey(name: "mKPayID", fromJson: Functions.asString)
  String? mKPayId;
  @JsonKey(name: "mKPaySecret", fromJson: Functions.asString)
  String? mKPaySecret;
  @JsonKey(name: "isShowPickUP", fromJson: Functions.asString)
  String? isShowPickUp;
  @JsonKey(name: "mPickupOnly", fromJson: Functions.asString)
  String? mPickupOnly;
  @JsonKey(name: "online_payment", fromJson: Functions.asString)
  String? onlinePayment;
  @JsonKey(name: "BBMSL_Merchant_ID", fromJson: Functions.asString)
  String? bbmslMerchantId;
  @JsonKey(name: "BBMSL_Private_Key", fromJson: Functions.asString)
  String? bbmslPrivateKey;
  @JsonKey(name: "Web_version_discount_amt", fromJson: Functions.asString)
  String? webVersionDiscountAmt;
  @JsonKey(name: "Web_version_service_fee", fromJson: Functions.asString)
  String? webVersionServiceFee;
  @JsonKey(name: "Web_version_discount", fromJson: Functions.asString)
  String? webVersionDiscount;
  @JsonKey(name: "Precision_to_decimal_places", fromJson: Functions.asString)
  String? precisionToDecimalPlaces;
  @JsonKey(name: "Accurate_method", fromJson: Functions.asString)
  String? accurateMethod;
  @JsonKey(name: "mPointDisplay", fromJson: Functions.asString)
  String? mPointDisplay;
  @JsonKey(name: "firebaseConfig", fromJson: Functions.asString)
  String? firebaseConfig;
  @JsonKey(name: "bbmsl_product_env", fromJson: Functions.asString)
  String? bbmslProductEnv;
  @JsonKey(name: "mQty_limit", fromJson: Functions.asString)
  String? mQtyLimit;
  @JsonKey(name: "sunmi_printer", fromJson: Functions.asString)
  String? sunmiPrinter;
  @JsonKey(name: "mFont_size", fromJson: Functions.asString)
  String? mFontSize;
  @JsonKey(name: "mPayment_Platform", fromJson: Functions.asString)
  String? mPaymentPlatform;
  @JsonKey(name: "mWonder_BusinessID", fromJson: Functions.asString)
  String? mWonderBusinessId;
  @JsonKey(name: "mWonder_AppSlug", fromJson: Functions.asString)
  String? mWonderAppSlug;
  @JsonKey(name: "mWonder_AppKey", fromJson: Functions.asString)
  String? mWonderAppKey;
  @JsonKey(name: "mWonder_POIID", fromJson: Functions.asString)
  String? mWonderPoiid;
  @JsonKey(name: "mWonder_Auth", fromJson: Functions.asString)
  String? mWonderAuth;
  @JsonKey(name: "mNotification_Email", fromJson: Functions.asString)
  String? mNotificationEmail;
  @JsonKey(name: "mSelf_login", fromJson: Functions.asString)
  String? mSelfLogin;
  @JsonKey(name: "auto_print_station", fromJson: Functions.asString)
  String? autoPrintStation;
  @JsonKey(name: "mAirPrint", fromJson: Functions.asString)
  String? mAirPrint;
  @JsonKey(name: "yeahpay_appid", fromJson: Functions.asString)
  String? yeahpayAppid;
  @JsonKey(name: "yeahpay_merchantid", fromJson: Functions.asString)
  String? yeahpayMerchantid;
  @JsonKey(name: "yeahpay_public_key", fromJson: Functions.asString)
  String? yeahpayPublicKey;
  @JsonKey(name: "yeahpay_client_private_key", fromJson: Functions.asString)
  String? yeahpayClientPrivateKey;
  @JsonKey(name: "Login_method", fromJson: Functions.asString)
  String? loginMethod;
  @JsonKey(name: "mBackup_printing_time", fromJson: Functions.asString)
  String? mBackupPrintingTime;
  @JsonKey(name: "app_home", fromJson: Functions.asString)
  String? appHome;
  @JsonKey(name: "mQrremark", fromJson: Functions.asString)
  String? mQrremark;

  Company({
    this.mNameChinese,
    this.mTel,
    this.mFax,
    this.mAddress,
    this.mEMail,
    this.mLogoPath,
    this.mWebSite,
    this.mNameEnglish,
    this.tCompanyId,
    this.mStockAdjustmentInPreFix,
    this.mStockAdjustmentInSubFix,
    this.mInitStockAdjustmentInNo,
    this.mStockInternalPreFix,
    this.mStockInternalSubFix,
    this.mInitStockInternalNo,
    this.mSupplierInvoiceInPreFix,
    this.mSupplierInvoiceInSubFix,
    this.mInitSupplierInvoiceInNo,
    this.mStockAdjustmentOutPreFix,
    this.mStockAdjustmentOutSubFix,
    this.mInitStockAdjustmentOutNo,
    this.mConsignmentInPreFix,
    this.mConsignmentInSubFix,
    this.mInitConsignmentInNo,
    this.mConsignmentOutPreFix,
    this.mConsignmentOutSubFix,
    this.mInitConsignmentOutNo,
    this.mTradingInvoicePreFix,
    this.mTradingInvoiceSubFix,
    this.mInitTradingInvoiceNo,
    this.mCustomerPreFix,
    this.mCustomerSubFix,
    this.mUpdateUrl,
    this.mUpdateVersion,
    this.mDefaultCustomer,
    this.mTradingInvoiceTerms,
    this.mSupplierInvoiceTerms,
    this.mExtend,
    this.mFtpServer,
    this.mFtpUser,
    this.mFtpPassword,
    this.mArCredItCode,
    this.mApDebItCode,
    this.mElectronicOrderingPreFix,
    this.mElectronicOrderingSubFix,
    this.mInitElectronicOrderingNo,
    this.mQrUrl,
    this.cloudPrintUser,
    this.cloudPrintKey,
    this.invoicePrinter,
    this.upperMenuPrinter,
    this.isPrintPrice,
    this.mTakeawayInformation,
    this.mFtpList,
    this.mKiosk2,
    this.mKiosk3,
    this.isCloudPrinter,
    this.atuoFoodList,
    this.takeawayPrinter,
    this.taAutoPrint,
    this.mNotify,
    this.mTableDisplay,
    this.mKPayId,
    this.mKPaySecret,
    this.isShowPickUp,
    this.mPickupOnly,
    this.onlinePayment,
    this.bbmslMerchantId,
    this.bbmslPrivateKey,
    this.webVersionDiscountAmt,
    this.webVersionServiceFee,
    this.webVersionDiscount,
    this.precisionToDecimalPlaces,
    this.accurateMethod,
    this.mPointDisplay,
    this.firebaseConfig,
    this.bbmslProductEnv,
    this.mQtyLimit,
    this.sunmiPrinter,
    this.mFontSize,
    this.mPaymentPlatform,
    this.mWonderBusinessId,
    this.mWonderAppSlug,
    this.mWonderAppKey,
    this.mWonderPoiid,
    this.mWonderAuth,
    this.mNotificationEmail,
    this.mSelfLogin,
    this.autoPrintStation,
    this.mAirPrint,
    this.yeahpayAppid,
    this.yeahpayMerchantid,
    this.yeahpayPublicKey,
    this.yeahpayClientPrivateKey,
    this.loginMethod,
    this.mBackupPrintingTime,
    this.appHome,
    this.mQrremark,
  });

  Company copyWith({
    String? mNameChinese,
    String? mTel,
    String? mFax,
    String? mAddress,
    String? mEMail,
    String? mLogoPath,
    String? mWebSite,
    String? mNameEnglish,
    String? tCompanyId,
    String? mStockAdjustmentInPreFix,
    String? mStockAdjustmentInSubFix,
    String? mInitStockAdjustmentInNo,
    String? mStockInternalPreFix,
    String? mStockInternalSubFix,
    String? mInitStockInternalNo,
    String? mSupplierInvoiceInPreFix,
    String? mSupplierInvoiceInSubFix,
    String? mInitSupplierInvoiceInNo,
    String? mStockAdjustmentOutPreFix,
    String? mStockAdjustmentOutSubFix,
    String? mInitStockAdjustmentOutNo,
    String? mConsignmentInPreFix,
    String? mConsignmentInSubFix,
    String? mInitConsignmentInNo,
    String? mConsignmentOutPreFix,
    String? mConsignmentOutSubFix,
    String? mInitConsignmentOutNo,
    String? mTradingInvoicePreFix,
    String? mTradingInvoiceSubFix,
    String? mInitTradingInvoiceNo,
    String? mCustomerPreFix,
    String? mCustomerSubFix,
    String? mUpdateUrl,
    String? mUpdateVersion,
    String? mDefaultCustomer,
    String? mTradingInvoiceTerms,
    String? mSupplierInvoiceTerms,
    String? mExtend,
    String? mFtpServer,
    String? mFtpUser,
    String? mFtpPassword,
    String? mArCredItCode,
    String? mApDebItCode,
    String? mElectronicOrderingPreFix,
    String? mElectronicOrderingSubFix,
    String? mInitElectronicOrderingNo,
    String? mQrUrl,
    String? cloudPrintUser,
    String? cloudPrintKey,
    String? invoicePrinter,
    String? upperMenuPrinter,
    String? isPrintPrice,
    String? mTakeawayInformation,
    String? mFtpList,
    String? mKiosk2,
    String? mKiosk3,
    String? isCloudPrinter,
    String? atuoFoodList,
    String? takeawayPrinter,
    String? taAutoPrint,
    String? mNotify,
    String? mTableDisplay,
    String? mKPayId,
    String? mKPaySecret,
    String? isShowPickUp,
    String? mPickupOnly,
    String? onlinePayment,
    String? bbmslMerchantId,
    String? bbmslPrivateKey,
    String? webVersionDiscountAmt,
    String? webVersionServiceFee,
    String? webVersionDiscount,
    String? precisionToDecimalPlaces,
    String? accurateMethod,
    String? mPointDisplay,
    String? firebaseConfig,
    String? bbmslProductEnv,
    String? mQtyLimit,
    String? sunmiPrinter,
    String? mFontSize,
    String? mPaymentPlatform,
    String? mWonderBusinessId,
    String? mWonderAppSlug,
    String? mWonderAppKey,
    String? mWonderPoiid,
    String? mWonderAuth,
    String? mNotificationEmail,
    String? mSelfLogin,
    String? autoPrintStation,
    String? mAirPrint,
    String? yeahpayAppid,
    String? yeahpayMerchantid,
    String? yeahpayPublicKey,
    String? yeahpayClientPrivateKey,
    String? loginMethod,
    String? mBackupPrintingTime,
    String? appHome,
    String? mQrremark,
  }) => Company(
    mNameChinese: mNameChinese ?? this.mNameChinese,
    mTel: mTel ?? this.mTel,
    mFax: mFax ?? this.mFax,
    mAddress: mAddress ?? this.mAddress,
    mEMail: mEMail ?? this.mEMail,
    mLogoPath: mLogoPath ?? this.mLogoPath,
    mWebSite: mWebSite ?? this.mWebSite,
    mNameEnglish: mNameEnglish ?? this.mNameEnglish,
    tCompanyId: tCompanyId ?? this.tCompanyId,
    mStockAdjustmentInPreFix: mStockAdjustmentInPreFix ?? this.mStockAdjustmentInPreFix,
    mStockAdjustmentInSubFix: mStockAdjustmentInSubFix ?? this.mStockAdjustmentInSubFix,
    mInitStockAdjustmentInNo: mInitStockAdjustmentInNo ?? this.mInitStockAdjustmentInNo,
    mStockInternalPreFix: mStockInternalPreFix ?? this.mStockInternalPreFix,
    mStockInternalSubFix: mStockInternalSubFix ?? this.mStockInternalSubFix,
    mInitStockInternalNo: mInitStockInternalNo ?? this.mInitStockInternalNo,
    mSupplierInvoiceInPreFix: mSupplierInvoiceInPreFix ?? this.mSupplierInvoiceInPreFix,
    mSupplierInvoiceInSubFix: mSupplierInvoiceInSubFix ?? this.mSupplierInvoiceInSubFix,
    mInitSupplierInvoiceInNo: mInitSupplierInvoiceInNo ?? this.mInitSupplierInvoiceInNo,
    mStockAdjustmentOutPreFix: mStockAdjustmentOutPreFix ?? this.mStockAdjustmentOutPreFix,
    mStockAdjustmentOutSubFix: mStockAdjustmentOutSubFix ?? this.mStockAdjustmentOutSubFix,
    mInitStockAdjustmentOutNo: mInitStockAdjustmentOutNo ?? this.mInitStockAdjustmentOutNo,
    mConsignmentInPreFix: mConsignmentInPreFix ?? this.mConsignmentInPreFix,
    mConsignmentInSubFix: mConsignmentInSubFix ?? this.mConsignmentInSubFix,
    mInitConsignmentInNo: mInitConsignmentInNo ?? this.mInitConsignmentInNo,
    mConsignmentOutPreFix: mConsignmentOutPreFix ?? this.mConsignmentOutPreFix,
    mConsignmentOutSubFix: mConsignmentOutSubFix ?? this.mConsignmentOutSubFix,
    mInitConsignmentOutNo: mInitConsignmentOutNo ?? this.mInitConsignmentOutNo,
    mTradingInvoicePreFix: mTradingInvoicePreFix ?? this.mTradingInvoicePreFix,
    mTradingInvoiceSubFix: mTradingInvoiceSubFix ?? this.mTradingInvoiceSubFix,
    mInitTradingInvoiceNo: mInitTradingInvoiceNo ?? this.mInitTradingInvoiceNo,
    mCustomerPreFix: mCustomerPreFix ?? this.mCustomerPreFix,
    mCustomerSubFix: mCustomerSubFix ?? this.mCustomerSubFix,
    mUpdateUrl: mUpdateUrl ?? this.mUpdateUrl,
    mUpdateVersion: mUpdateVersion ?? this.mUpdateVersion,
    mDefaultCustomer: mDefaultCustomer ?? this.mDefaultCustomer,
    mTradingInvoiceTerms: mTradingInvoiceTerms ?? this.mTradingInvoiceTerms,
    mSupplierInvoiceTerms: mSupplierInvoiceTerms ?? this.mSupplierInvoiceTerms,
    mExtend: mExtend ?? this.mExtend,
    mFtpServer: mFtpServer ?? this.mFtpServer,
    mFtpUser: mFtpUser ?? this.mFtpUser,
    mFtpPassword: mFtpPassword ?? this.mFtpPassword,
    mArCredItCode: mArCredItCode ?? this.mArCredItCode,
    mApDebItCode: mApDebItCode ?? this.mApDebItCode,
    mElectronicOrderingPreFix: mElectronicOrderingPreFix ?? this.mElectronicOrderingPreFix,
    mElectronicOrderingSubFix: mElectronicOrderingSubFix ?? this.mElectronicOrderingSubFix,
    mInitElectronicOrderingNo: mInitElectronicOrderingNo ?? this.mInitElectronicOrderingNo,
    mQrUrl: mQrUrl ?? this.mQrUrl,
    cloudPrintUser: cloudPrintUser ?? this.cloudPrintUser,
    cloudPrintKey: cloudPrintKey ?? this.cloudPrintKey,
    invoicePrinter: invoicePrinter ?? this.invoicePrinter,
    upperMenuPrinter: upperMenuPrinter ?? this.upperMenuPrinter,
    isPrintPrice: isPrintPrice ?? this.isPrintPrice,
    mTakeawayInformation: mTakeawayInformation ?? this.mTakeawayInformation,
    mFtpList: mFtpList ?? this.mFtpList,
    mKiosk2: mKiosk2 ?? this.mKiosk2,
    mKiosk3: mKiosk3 ?? this.mKiosk3,
    isCloudPrinter: isCloudPrinter ?? this.isCloudPrinter,
    atuoFoodList: atuoFoodList ?? this.atuoFoodList,
    takeawayPrinter: takeawayPrinter ?? this.takeawayPrinter,
    taAutoPrint: taAutoPrint ?? this.taAutoPrint,
    mNotify: mNotify ?? this.mNotify,
    mTableDisplay: mTableDisplay ?? this.mTableDisplay,
    mKPayId: mKPayId ?? this.mKPayId,
    mKPaySecret: mKPaySecret ?? this.mKPaySecret,
    isShowPickUp: isShowPickUp ?? this.isShowPickUp,
    mPickupOnly: mPickupOnly ?? this.mPickupOnly,
    onlinePayment: onlinePayment ?? this.onlinePayment,
    bbmslMerchantId: bbmslMerchantId ?? this.bbmslMerchantId,
    bbmslPrivateKey: bbmslPrivateKey ?? this.bbmslPrivateKey,
    webVersionDiscountAmt: webVersionDiscountAmt ?? this.webVersionDiscountAmt,
    webVersionServiceFee: webVersionServiceFee ?? this.webVersionServiceFee,
    webVersionDiscount: webVersionDiscount ?? this.webVersionDiscount,
    precisionToDecimalPlaces: precisionToDecimalPlaces ?? this.precisionToDecimalPlaces,
    accurateMethod: accurateMethod ?? this.accurateMethod,
    mPointDisplay: mPointDisplay ?? this.mPointDisplay,
    firebaseConfig: firebaseConfig ?? this.firebaseConfig,
    bbmslProductEnv: bbmslProductEnv ?? this.bbmslProductEnv,
    mQtyLimit: mQtyLimit ?? this.mQtyLimit,
    sunmiPrinter: sunmiPrinter ?? this.sunmiPrinter,
    mFontSize: mFontSize ?? this.mFontSize,
    mPaymentPlatform: mPaymentPlatform ?? this.mPaymentPlatform,
    mWonderBusinessId: mWonderBusinessId ?? this.mWonderBusinessId,
    mWonderAppSlug: mWonderAppSlug ?? this.mWonderAppSlug,
    mWonderAppKey: mWonderAppKey ?? this.mWonderAppKey,
    mWonderPoiid: mWonderPoiid ?? this.mWonderPoiid,
    mWonderAuth: mWonderAuth ?? this.mWonderAuth,
    mNotificationEmail: mNotificationEmail ?? this.mNotificationEmail,
    mSelfLogin: mSelfLogin ?? this.mSelfLogin,
    autoPrintStation: autoPrintStation ?? this.autoPrintStation,
    mAirPrint: mAirPrint ?? this.mAirPrint,
    yeahpayAppid: yeahpayAppid ?? this.yeahpayAppid,
    yeahpayMerchantid: yeahpayMerchantid ?? this.yeahpayMerchantid,
    yeahpayPublicKey: yeahpayPublicKey ?? this.yeahpayPublicKey,
    yeahpayClientPrivateKey: yeahpayClientPrivateKey ?? this.yeahpayClientPrivateKey,
    loginMethod: loginMethod ?? this.loginMethod,
    mBackupPrintingTime: mBackupPrintingTime ?? this.mBackupPrintingTime,
    appHome: appHome ?? this.appHome,
    mQrremark: mQrremark ?? this.mQrremark,
  );

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
