class Config {
  ///默认padding
  static double defaultPadding = 10;

  ///默认间隙
  static double defaultGap = 10;
  //本地登录信息
  static String localStroageloginInfo = "localStroageLoginInfo";
  //登录标识
  static String localStroagehasLogin = "localStroageHasLogin";
  //本地语言
  static String localStroagelanguage = "localStroageLanguage";
  //没有权限标识
  static String noPermission = "__NO_PERMISSION__";

  ///网络请求地址
  //static String baseurl = "https://api.friendsclub.com/restAdmin";
  static String baseurl = "http://www.api.cn/restAdmin";

  /// 登录
  //登录
  static String login = "/Login/login";
  //退出登录
  static String logout = "/Login/logout";

  /// 销售概述
  static String chartData = "/dashboard/chartData";

  /// 主档
  // 图片上传
  static String uploadProductImage = "/Master/uploadImage";
  // 获取产品列表
  static String product = "/Master/product";
  // 获取产品详情
  static String productDetail = "/Master/productDetail";
  // 进阶搜索
  static String productadvancedSearch = "/Master/advancedSearch";
  // 批量删除食品
  static String batchDeleteProduct = "/Master/batchDeleteProduct";
  // 批量删除套餐
  static String batchDeleteSetMeal = "/Master/batchDeleteSetMeal";
  // 打印条码
  static String printBarcode = "/Master/printBarcode";

  /// 打开选择
  // 供应商
  static String openSupplier = "/Open/supplier";
  // 食品
  static String openProduct = "/Open/product";
  // 打开条码
  static String openBarcode = "/Open/barcode";

  /// excel
  // 导出产品
  static String exportProductExcel = "/Excel/productExport";
  // 导入产品
  static String importProductExcel = "/Excel/productImport";
  //导出套餐
  static String exportSetMealExcel = "/Excel/setMealExport";
}
