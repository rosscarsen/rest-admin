import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../config.dart';
import '../../../../mixin/loading_state_mixin.dart';
import '../../../../model/currency/currency_data.dart';
import '../../../../model/customer/customer_contact.dart';
import '../../../../model/customer/customer_data.dart';
import '../../../../model/customer/customer_edit_model.dart';
import '../../../../model/customer/point_list.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../customer_controller.dart';
import '../customer_fields.dart';
import 'contact_add_or_edit_view.dart';
import 'contact_data_source.dart';
import 'point_add_or_edit_view.dart';
import 'point_data_source.dart';

class CustomerEditController extends GetxController with GetSingleTickerProviderStateMixin, LoadingStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();
  static CustomerEditController get to => Get.find();
  // Dio客户端
  final ApiClient apiClient = ApiClient();

  String? id;

  late TabController tabController;
  final tabIndex = 0.obs;
  late PointDetailDataSource pointDataSource;
  late ContactDataSource contactDataSource;
  List<PointData> pointList = [];
  List<CustomerContact> customerContactList = [];
  List<CurrencyData> currencyList = [];
  List<CustomerDiscount> customerDiscountList = [];
  CustomerEditResult? customerRet;
  final customerCtl = Get.find<CustomerController>();

  final customerTypeList = <String>[];

  String? invoiceAmount;
  String? get getInvoiceAmount => invoiceAmount;
  set setInvoiceAmount(String invoiceAmount) {
    this.invoiceAmount = Functions.formatAmount(invoiceAmount);
    update(["amount"]);
  }

  String? customerPoint;
  String? get getCustomerPoint => customerPoint;
  set setCustomerPoint(String customerPoint) {
    this.customerPoint = Functions.formatAmount(customerPoint);
    update(["amount"]);
  }

  //记录编辑前的积分
  String beforeEditPoint = "0.00";

  @override
  void onInit() {
    super.onInit();
    title = LocaleKeys.addCustomer.tr;
    final params = Get.parameters;

    id = params['id'];
    if (id != null) {
      title = LocaleKeys.editCustomer.tr;
      tabController = TabController(vsync: this, length: 3);
    } else {
      tabController = TabController(vsync: this, length: 2);
    }
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    addOrEdit().then((_) {
      pointDataSource = PointDetailDataSource(this);
      contactDataSource = ContactDataSource(this);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// 更新积分数据源
  void updateDepositDataSource() {
    totalPages = 0;
    currentPage = 1;
    getDepositList().then((_) {
      pointDataSource = PointDetailDataSource(this);
    });
  }

  /// 获取积分列表
  Future<void> getDepositList() async {
    isLoading = true;
    pointList.clear();
    try {
      final DioApiResult pointResult = await apiClient.get(Config.customerPoint, data: {'page': currentPage, 'id': id});
      if (pointResult.success) {
        final pointData = pointResult.data;
        if (pointData != null) {
          final pointListModel = pointListFromJson(pointData);
          if (pointListModel.status == 200) {
            pointList.addAll(pointListModel.pointResult?.pointData ?? []);
          }
        }
      }
    } finally {
      isLoading = false;
    }
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading = true;
    customerContactList.clear();
    customerTypeList.clear();
    currencyList.clear();
    customerDiscountList.clear();
    customerRet = null;
    pointList.clear();

    final futures = [
      apiClient.get(Config.customerPoint, data: {'page': currentPage, 'id': id}),
      apiClient.get(Config.customerAddOrEdit, data: {'id': id}),
    ];
    try {
      final results = await Future.wait(futures);
      // 积分列表
      final DioApiResult pointResult = results[0];
      if (pointResult.success) {
        final pointData = pointResult.data;
        if (pointData != null) {
          final pointListModel = pointListFromJson(pointData);
          if (pointListModel.status == 200) {
            pointList.addAll(pointListModel.pointResult?.pointData ?? []);
            totalPages = pointListModel.pointResult?.lastPage ?? 0;
            totalRecords = pointListModel.pointResult?.total ?? 0;
          }
        }
      }

      final DioApiResult customerResult = results[1];
      if (!customerResult.success) {
        if (!customerResult.hasPermission) {
          hasPermission = false;
        }
        CustomDialog.errorMessages(customerResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (customerResult.data == null) {
        CustomDialog.errorMessages(LocaleKeys.dataException.tr);
        return;
      }

      hasPermission = true;
      logger.f(customerResult.data);
      final resultModel = customerEditModelFromJson(customerResult.data);
      customerRet = resultModel.apiResult;
      customerTypeList.addAll(customerRet?.customerType ?? []);
      currencyList.addAll(customerRet?.currency ?? []);
      customerContactList.addAll(customerRet?.customerContact ?? []);
      customerDiscountList.addAll(customerRet?.customerDiscount ?? []);
      setInvoiceAmount = customerRet?.invoiceAmount ?? "";
      setCustomerPoint = customerRet?.customerPoint ?? "";
      final customerInfo = customerRet?.customerInfo;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formKey.currentState?.patchValue(customerInfo?.toJson() ?? {});
      });
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading = false;
    }
  }

  /// 保存
  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.saveAndValidate() ?? false) {
      CustomDialog.showLoading(LocaleKeys.saving.tr);
      final formData = Map<String, dynamic>.from(formKey.currentState?.value ?? {});
      if (GetUtils.isMD5(formData[CustomerFields.mPassword]?.toString() ?? "")) {
        formData.remove(CustomerFields.mPassword);
      } else {
        formData[CustomerFields.mPassword] = md5
            .convert(utf8.encode(formData[CustomerFields.mPassword]?.toString() ?? ""))
            .toString();
      }
      formData
        ..addAll({"T_Customer_ID": id})
        ..addAll({"customerContact": customerContactList})
        ..addAll({"customerDiscount": customerDiscountList});

      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.customerSave, data: formData);
        if (!dioApiResult.success) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
          return;
        }
        final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
        switch (data["status"]) {
          case 200:
            CustomDialog.successMessages(id == null ? LocaleKeys.addSuccess.tr : LocaleKeys.updateSuccess.tr);
            final apiResult = data["apiResult"];
            if (apiResult == null) {
              CustomerController.to.reloadData();
              Get.back();
              return;
            }
            final resultModel = CustomerData.fromJson(apiResult);
            final customerCtl = Get.find<CustomerController>();
            if (id == null) {
              customerCtl.dataList.insert(0, resultModel);
            } else {
              final index = customerCtl.dataList.indexWhere((element) => element.tCustomerId.toString() == id);
              if (index != -1) {
                customerCtl.dataList[index] = resultModel;
              }
            }
            customerCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.code.tr]));
            break;
          case 202:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.mobile.tr]));
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
        }
      } catch (e) {
        CustomDialog.errorMessages(e.toString());
      } finally {
        CustomDialog.dismissDialog();
      }
    }
  }

  /// 编辑联络人
  Future<void> editOrAddContact({CustomerContact? row}) async {
    Get.dialog(Dialog(child: ContactAddOrEditView(contactData: row)));
  }

  /// 编辑积分
  Future<void> editOrAddPoint({required PointData row, required bool isAdd}) async {
    beforeEditPoint = "0.00";
    beforeEditPoint = row.mAmount ?? "0.00";
    Get.dialog(
      Dialog(
        child: PointAddOrEditView(pointData: row, isAdd: isAdd),
      ),
    );
  }

  /// 保存客户积分
  Future<void> saveCustomerPoint({required PointData row, required bool isAdd}) async {
    CustomDialog.showLoading(isAdd ? LocaleKeys.adding.tr : LocaleKeys.updating.tr);
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.customerPointSave, data: row.toJson());
      logger.f(dioApiResult);
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
      switch (data["status"]) {
        case 200:
          CustomDialog.successMessages(isAdd ? LocaleKeys.addSuccess.tr : LocaleKeys.updateSuccess.tr);
          final apiResult = data["apiResult"];
          final resultModel = PointData.fromJson(apiResult);
          if (isAdd) {
            pointList.insert(0, resultModel);
          } else {
            final index = pointList.indexWhere((element) => element.mRefNo == row.mRefNo);
            if (index != -1) {
              pointList[index] = resultModel;
            }
          }
          pointDataSource.updateDataSource();
          final oldPoint = double.tryParse(beforeEditPoint);
          final newPoint = double.tryParse(resultModel.mAmount ?? "0.00");
          final tempCustomerPoint = double.tryParse(getCustomerPoint?.replaceAll(RegExp(r'[,\s]'), '') ?? "0.00");
          final newCustomerPoint = (tempCustomerPoint ?? 0.0) - (oldPoint ?? 0.0) + (newPoint ?? 0.0);
          setCustomerPoint = newCustomerPoint.toStringAsFixed(2);
          update(["amount"]);
          break;
        default:
          CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(e.toString());
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 删除客户积分
  Future<void> deleteCustomerPoint({PointData? row}) async {
    if (row == null) {
      return;
    }
    try {
      CustomDialog.showLoading(LocaleKeys.deleting.tr);
      final DioApiResult dioApiResult = await apiClient.post(
        Config.customerPointDelete,
        data: {"t_customer_id": row.tCustomerId, "mItem": row.mItem},
      );
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
      switch (data["status"]) {
        case 200:
          CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
          pointList.remove(row);
          pointDataSource.updateDataSource();
          final oldPoint = double.tryParse(row.mAmount ?? "0.00");
          final newCustomerPoint =
              (double.tryParse(getCustomerPoint?.replaceAll(RegExp(r'[,\s]'), '') ?? "0.00") ?? 0.0) -
              (oldPoint ?? 0.0);
          setCustomerPoint = newCustomerPoint.toStringAsFixed(2);
          update(["amount"]);
          break;
        default:
          CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(e.toString());
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 添加或修改客户折扣
  Future<void> addOrEditCustomerDiscount({CustomerDiscount? row, bool isAdd = true}) async {
    if (row == null) {
      return;
    }
    if (isAdd) {
      customerDiscountList.add(row);
    }
    update(["customerDiscountList"]);
  }

  /// 删除客户折扣
  Future<void> deleteCustomerDiscount({CustomerDiscount? row}) async {
    if (row == null) {
      return;
    }
    customerDiscountList.remove(row);
    update(["customerDiscountList"]);
  }
}
