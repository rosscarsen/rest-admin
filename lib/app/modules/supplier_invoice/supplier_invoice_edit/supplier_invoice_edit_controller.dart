import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/currency/currency_data.dart';
import '../../../model/login_model.dart';
import '../../../model/stock/stock_data.dart';
import '../../../model/supplierInvoice/supplier_invoice_api_model.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/logger.dart';
import '../../../utils/storage_manage.dart';
import '../model/supplier_invoice_edit_model.dart';
import '../supplier_invoice_controller.dart';
import '../supplier_invoice_fields.dart';
import 'supplier_invoice_detail_data_source.dart';

class SupplierInvoiceEditController extends GetxController with LoadingStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final StorageManage storageManage = StorageManage();

  /// Dio客户端
  final ApiClient apiClient = ApiClient();

  String? id;

  /// 表格是否可用
  bool formEnabled = true;

  late SupplierInvoiceDetailDataSource dataSource;

  /// 表格高度
  final tableHeight = 100.00.obs;

  /// 数据
  Invoice? invoice;
  List<InvoiceDetail> invoiceDetail = [];
  List<CurrencyData> currency = [];
  List<StockData> stock = [];

  @override
  void onInit() {
    super.onInit();
    title = LocaleKeys.addParam.trArgs([LocaleKeys.supplierInvoice.tr]);
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title = LocaleKeys.editParam.trArgs([LocaleKeys.supplierInvoice.tr]);
      }
    }
    updateDataGridSource();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 更新数据源
  void updateDataGridSource() {
    addOrEdit().then((_) {
      updateTableHeight();
      dataSource = SupplierInvoiceDetailDataSource(this);
    });
  }

  /// 更新表格高度
  void updateTableHeight() {
    tableHeight.value = invoiceDetail.isNotEmpty
        ? (100 + invoiceDetail.length * 48) > 300
              ? 300
              : (100 + invoiceDetail.length * 48)
        : 100;
  }

  /// 获取缓存用户
  Future<void> getCacheUser() async {
    final localStorageLoginInfo = storageManage.read(Config.localStorageLoginInfo);
    final LoginResult? loginUser = localStorageLoginInfo != null ? LoginResult.fromJson(localStorageLoginInfo) : null;
    if (id == null) {
      formKey.currentState?.patchValue({
        SupplierInvoiceFields.createdBy: loginUser?.user ?? "",
        SupplierInvoiceFields.lastModifiedBy: loginUser?.user ?? "",
      });
    } else {
      formKey.currentState?.fields[SupplierInvoiceFields.lastModifiedBy]?.didChange(loginUser?.user ?? "");
    }
  }

  @override
  void onReady() {
    getCacheUser();
    super.onReady();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading = true;
    try {
      final DioApiResult dioApiResult = await apiClient.get(Config.supplierInvoiceAddOrEdit, data: {'id': id});
      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(LocaleKeys.dataException.tr);
        return;
      }

      hasPermission = true;
      final resultModel = supplierInvoiceEditModelFromJson(dioApiResult.data);
      final apiData = resultModel.apiResult;
      if (apiData == null) {
        return;
      }
      invoice = apiData.invoice;
      invoiceDetail
        ..clear()
        ..addAll(apiData.invoiceDetail ?? []);
      currency
        ..clear()
        ..addAll(apiData.currency ?? []);
      stock
        ..clear()
        ..addAll(apiData.stock ?? []);

      formEnabled = apiData.invoice?.mFlag != "1";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formKey.currentState?.fields["defaultStock"]?.didChange(stock.firstOrNull?.mCode ?? "");
        formKey.currentState?.fields[SupplierInvoiceFields.moneyCurrency]?.didChange(currency.firstOrNull?.mCode ?? "");
        formKey.currentState?.patchValue(
          Map.fromEntries(
            apiData.invoice
                    ?.toJson()
                    .entries
                    .where((e) => (e.value?.toString() ?? "").trim().isNotEmpty)
                    .map((e) => MapEntry(e.key, e.value.toString())) ??
                [],
          ),
        );
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
      final formData = Map<String, dynamic>.from(formKey.currentState?.value ?? {})
        ..addAll({"id": id})
        ..addAll({"detail": invoiceDetail.map((e) => e.toJson()).toList()});
      logger.f(formData);
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.supplierInvoiceSave, data: formData);
        logger.f(dioApiResult);
        if (!dioApiResult.success) {
          CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
          return;
        }
        final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
        final preCtl = Get.find<SupplierInvoiceController>();
        switch (data["status"]) {
          case 200:
            CustomDialog.successMessages(id == null ? LocaleKeys.addSuccess.tr : LocaleKeys.updateSuccess.tr);
            final apiResult = data["apiResult"];
            if (apiResult == null) {
              preCtl.reloadData();
              Get.back();
              return;
            }
            final resultModel = Invoice.fromJson(apiResult);

            if (id == null) {
              preCtl.dataList.insert(0, resultModel);
            } else {
              final index = preCtl.dataList.indexWhere((element) => element.tSupplierInvoiceInId.toString() == id);
              if (index != -1) {
                preCtl.dataList[index] = resultModel;
              }
            }
            preCtl.dataSource.updateDataSource();
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

  /// 修改行金额
  void updateRowAmount({required InvoiceDetail? row}) {
    if (row == null) {
      return;
    }
    final index = invoiceDetail.indexOf(row);
    if (index == -1) {
      return;
    }
    final qty = double.tryParse(row.mQty ?? "0") ?? 0;
    final price = double.tryParse(row.mPrice ?? "0") ?? 0;
    final discount = double.tryParse(row.mDiscount ?? "0") ?? 0;
    final newAmount = ((qty * price * (100 - discount)) / 100).toStringAsFixed(2);
    row.mAmount = newAmount;
    dataSource.updateAmountCell(index, newAmount);
    updateTotalAmount();
  }

  /// 修改总金额
  void updateTotalAmount() {
    // 总折扣
    final totalDiscount = formKey.currentState?.fields[SupplierInvoiceFields.discount]?.value ?? "0.00";
    // 总金额
    final totalAmount = invoiceDetail.fold(0.0, (sum, e) => sum + (double.tryParse(e.mAmount ?? "0") ?? 0));
    // 最后金额
    final lastAmount = totalAmount * (100 - (double.tryParse(totalDiscount) ?? 0)) / 100;
    formKey.currentState?.fields[SupplierInvoiceFields.amount]?.didChange(lastAmount.toStringAsFixed(2));
  }
}
