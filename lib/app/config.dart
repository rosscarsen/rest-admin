class Config {
  ///默认padding
  static double defaultPadding = 10;

  ///默认间隙
  static double defaultGap = 10;
  //本地登录信息
  static String localStorageLoginInfo = "localStorageLoginInfo";
  //登录标识
  static String localStorageHasLogin = "localStorageHasLogin";
  //本地语言
  static String localStorageLanguage = "localStorageLanguage";
  //没有权限标识
  static String noPermission = "__NO_PERMISSION__";

  ///网络请求地址
  static String baseurl = "https://api.friendsclub.com/restAdmin";
  //static String baseurl = "http://www.api.cn/restAdmin";

  // **************************************************************************
  // 登录模块
  // **************************************************************************
  // 登录
  static String login = "/Login/login";
  // 退出登录
  static String logout = "/Login/logout";
  // 销售概述
  static String chartData = "/dashboard/chartData";

  // **************************************************************************
  // 主档模块
  // **************************************************************************

  // ==========================================================================
  // 产品管理模块
  // ==========================================================================

  // 图片上传
  static String uploadProductImage = "/Master/uploadImage";
  // 获取产品列表
  static String product = "/Master/product";
  // 获取产品详情
  static String productDetail = "/Master/productDetail";
  // 进阶搜索
  static String productAdvancedSearch = "/Master/advancedSearch";
  // 批量删除食品
  static String batchDeleteProduct = "/Master/batchDeleteProduct";
  // 批量删除套餐
  static String batchDeleteSetMeal = "/Master/batchDeleteSetMeal";
  // 打印条码
  static String printBarcode = "/Master/printBarcode";
  // 新增或编辑
  static String productAddOrEdit = "/Master/productAddOrEdit";
  // 新增或编辑保存
  static String productAddOrEditSave = "/Master/productAddOrEditSave";
  // 复制
  static String copyProduct = "/Master/copyProduct";
  // 更新套餐
  static String productSetMealSave = "/Master/productSetMealSave";
  // 添加套餐
  static String addProductSetMeal = "/Master/addProductSetMeal";
  // 删除套餐
  static String deleteProductSetMeal = "/Master/deleteProductSetMeal";
  // 从食品复制套餐
  static String copyProductSetMeal = "/Master/copyProductSetMeal";
  // 清除产品表setMenu栏位
  static String updateSetMenu = "/Master/updateSetMenu";
  // 更新食品套餐
  static String updateProductSetMeal = "/Master/updateProductSetMeal";
  // 导出产品
  static String exportProductExcel = "/Excel/exportProduct";
  // 导入产品
  static String importProductExcel = "/Excel/importProduct";
  // 导出套餐
  static String exportSetMealExcel = "/Excel/setMealExport";

  // ==========================================================================
  // 类目管理模块
  // ==========================================================================

  // 类目1列表
  static String categories = "/Master/categories";
  // 类目添加或编辑
  static String categoryAddOrEdit = "/Master/categoryAddOrEdit";
  // 类目保存
  static String categorySave = "/Master/categorySave";
  // 类目删除
  static String categoryDelete = "/Master/categoryDelete";
  // 导出类目
  static String exportCategoryExcel = "/Excel/categoryExport";
  // 导入类目
  static String importCategoryExcel = "/Excel/categoryImport";
  // 类目1列表
  static String category2 = "/Master/category2";
  // 类目2添加或编辑
  static String category2AddOrEdit = "/Master/category2AddOrEdit";
  // 类目2保存
  static String category2Save = "/Master/category2Save";
  // 类目2删除
  static String category2Delete = "/Master/category2Delete";

  // ==========================================================================
  // 打印机管理模块
  // ==========================================================================

  // 打印机列表
  static String printer = "/Master/printer";
  // 打印机添加或编辑
  static String printerAddOrEdit = "/Master/printerAddOrEdit";
  // 打印机保存
  static String printerSave = "/Master/printerSave";
  // 打印机删除
  static String printerDelete = "/Master/printerDelete";

  // ==========================================================================
  // 食品备注管理模块
  // ==========================================================================

  // 食品备注列表
  static String productRemark = "/Master/productRemark";
  // 食品备注添加或编辑
  static String productRemarkAddOrEdit = "/Master/productRemarkAddOrEdit";
  // 食品备注保存
  static String productRemarkSave = "/Master/productRemarkSave";
  // 食品备注删除
  static String productRemarkDelete = "/Master/productRemarkDelete";
  // 复制
  static String productRemarkCopy = "/Master/productRemarkCopy";
  // 导出食品备注
  static String exportProductRemarkExcel = "/Excel/productRemarkExport";
  // 导入食品备注
  static String importProductRemarkExcel = "/Excel/productRemarkImport";

  // ==========================================================================
  // 客户管理模块
  // ==========================================================================

  // 客户列表
  static String customer = "/Master/customer";
  // 客户积分列表
  static String customerPoint = "/Master/customerPoint";
  // 客户类型
  static String customerType = "/Master/customerType";
  // 客户添加或编辑
  static String customerAddOrEdit = "/Master/customerAddOrEdit";
  // 客户保存
  static String customerSave = "/Master/customerSave";
  // 客户删除
  static String customerDelete = "/Master/customerDelete";
  // 复制
  static String customerCopy = "/Master/customerCopy";
  // 导出客户
  static String exportCustomerExcel = "/Excel/customerExport";
  // 导入客户
  static String importCustomerExcel = "/Excel/customerImport";
  // 保存客户积分
  static String customerPointSave = "/Master/customerPointSave";
  // 删除客户积分
  static String customerPointDelete = "/Master/customerPointDelete";

  // ==========================================================================
  // 供应商管理模块
  // ==========================================================================

  // 供应商列表
  static String supplier = "/Master/supplier";
  // 供应商添加或编辑
  static String supplierAddOrEdit = "/Master/supplierAddOrEdit";
  // 供应商保存
  static String supplierSave = "/Master/supplierSave";
  // 供应商删除
  static String supplierDelete = "/Master/supplierDelete";
  // 导出供应商
  static String exportSupplierExcel = "/Excel/supplierExport";
  // 导入供应商
  static String importSupplierExcel = "/Excel/supplierImport";

  // ==========================================================================
  // 店铺管理模块
  // ==========================================================================

  // 店铺列表
  static String stock = "/Master/stock";
  // 店铺添加或编辑
  static String stockAddOrEdit = "/Master/stockAddOrEdit";
  // 店铺保存
  static String stockSave = "/Master/stockSave";
  // 店铺删除
  static String stockDelete = "/Master/stockDelete";

  // ==========================================================================
  // 货币管理模块
  // ==========================================================================

  // 货币列表
  static String currency = "/Master/currency";
  // 货币添加或编辑
  static String currencyAddOrEdit = "/Master/currencyAddOrEdit";
  // 货币保存
  static String currencySave = "/Master/currencySave";
  // 货币删除
  static String currencyDelete = "/Master/currencyDelete";

  // ==========================================================================
  // 单位管理模块
  // ==========================================================================

  // 单位列表
  static String unit = "/Master/unit";
  // 单位添加或编辑
  static String unitAddOrEdit = "/Master/unitAddOrEdit";
  // 单位保存
  static String unitSave = "/Master/unitSave";
  // 单位删除
  static String unitDelete = "/Master/unitDelete";

  // ==========================================================================
  // 套餐管理模块
  // ==========================================================================

  // 套餐列表
  static String setMenu = "/Master/setMenu";
  // 套餐添加或编辑
  static String setMenuAddOrEdit = "/Master/setMenuAddOrEdit";
  // 套餐保存
  static String setMenuSave = "/Master/setMenuSave";
  // 套餐删除
  static String setMenuDelete = "/Master/setMenuDelete";
  // 导入套餐
  static String importSetMenu = "/Excel/setMealImport";
  // 套餐复制
  static String setMenuCopy = "/Master/setMenuCopy";
  // 删除套餐明细Item
  static String deleteMenuDetail = "/Master/deleteMenuDetail";
  // 套餐明细编辑
  static String setMenuDetailSave = "/Master/setMenuDetailSave";
  // 套餐明细复制
  static String copySetMenuDetail = "/Master/copySetMenuDetail";
  // 套餐明细添加或编辑
  static String addSetMenuDetail = "/Master/addSetMenuDetail";

  // **************************************************************************
  // 供应商商品发票
  // **************************************************************************

  // 发票列表
  static String supplierInvoice = "/SupplierInvoice/invoice";
  // 发票添加或编辑
  static String supplierInvoiceAddOrEdit = "/SupplierInvoice/invoiceAddOrEdit";
  // 发票保存
  static String supplierInvoiceSave = "/SupplierInvoice/invoiceSave";
  // 发票删除
  static String supplierInvoiceDelete = "/SupplierInvoice/invoiceDelete";
  // 过账
  static String supplierInvoicePosting = "/SupplierInvoice/invoicePosting";
  // 打印PDf
  static String getSupplierInvoicePdf = "/SupplierInvoice/invoicePrintPdf";

  // **************************************************************************
  // 打开选择
  // **************************************************************************

  // 供应商
  static String openSupplier = "/Open/supplier";
  // 食品
  static String openProduct = "/Open/product";
  // 打开条码
  static String openBarcode = "/Open/barcode";
  // 打开食品备注
  static String openProductRemark = "/Open/productRemark";
  // 打开套餐
  static String openSetMeal = "/Open/setMeal";
  // 打开食品套餐
  static String openProductSetMeal = "/open/productSetMeal";
  // 打开打印机列表
  static String openPrinter = "/open/printer";
  // 打开客户列表
  static String openCustomer = "/open/customer";
  // 打开类目
  static String openCategory = "/open/category";

  // **************************************************************************
  // excel
  // **************************************************************************
}
