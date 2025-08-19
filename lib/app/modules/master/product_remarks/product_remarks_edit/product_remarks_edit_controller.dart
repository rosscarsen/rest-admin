import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import '../../../../config.dart';
import '../../../../model/product_remarks_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../product_remarks_controller.dart';
import 'product_remarks_detail_data_source.dart';
import 'product_remarks_fields.dart';

class ProductRemarksEditController extends GetxController with GetSingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  // Dio客户端
  final ApiClient apiClient = ApiClient();
  final title = LocaleKeys.addProductRemarks.tr.obs;
  // 权限
  final hasPermission = true.obs;
  String? id;
  // 加载标识
  final isLoading = true.obs;
  late final TabController tabController = TabController(vsync: this, length: 2);
  final tabIndex = 0.obs;
  late ProductRemarksDetailDataSource dataSource;
  List<RemarksDetail> dataList = [];
  @override
  void onInit() {
    super.onInit();
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      FocusManager.instance.primaryFocus?.unfocus();
    });
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title.value = LocaleKeys.editProductRemarks.tr;
      }
    }
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    addOrEdit().then((_) {
      dataSource = ProductRemarksDetailDataSource(this);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await addOrEdit();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading(true);
    try {
      final DioApiResult dioApiResult = await apiClient.post(Config.productRemarkAddOrEdit, data: {'id': id});
      logger.e(dioApiResult);
      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }

      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(LocaleKeys.dataException.tr);
        return;
      }

      hasPermission.value = true;
      final data = json.decode(dioApiResult.data!) as Map<String, dynamic>;
      final apiResult = data["apiResult"];
      if (apiResult == null) {
        return;
      }
      final ProductRemarksInfo resultModel = ProductRemarksInfo.fromJson(apiResult);
      dataList
        ..clear()
        ..addAll(resultModel.remarksDetails ?? []);
      formKey.currentState?.patchValue(
        Map.fromEntries(
          resultModel.toJson().entries.where((e) => e.value != null).map((e) {
            final key = e.key;
            var value = e.value;
            if (['mVisible'].contains(key)) {
              value = !(value == 1 || value == '1');
            } else if (value != null) {
              value = value.toString();
            }
            return MapEntry(key, value);
          }),
        ),
      );
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (e) {
      logger.i(e.toString());
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading(false);
    }
  }

  /// 保存
  Future<void> save() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final productRemarksCtl = Get.find<ProductRemarksController>();
      CustomDialog.showLoading(id == null ? LocaleKeys.adding.tr : LocaleKeys.updating.tr);
      final Map<String, dynamic> formData = {ProductRemarksFields.mId: id, ...formKey.currentState?.value ?? {}};
      if (id != null) {
        final oldRow = productRemarksCtl.dataList.firstWhereOrNull((e) => e.mId.toString() == id);
        if (oldRow != null) {
          final isSame = Functions.compareMap(oldRow.toJson(), formData);
          if (isSame) {
            CustomDialog.dismissDialog();
            Get.back();
            return;
          }
        }
      }
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.productRemarkSave, data: formData);
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
              productRemarksCtl.reloadData();
              Get.back();
              return;
            }
            final resultModel = ProductRemarksInfo.fromJson(apiResult);
            if (id == null) {
              productRemarksCtl.dataList.insert(0, resultModel);
            } else {
              final index = productRemarksCtl.dataList.indexWhere((element) => element.mId.toString() == id);
              if (index != -1) {
                productRemarksCtl.dataList[index] = resultModel;
              }
            }
            productRemarksCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(
              LocaleKeys.codeExists.trArgs([formKey.currentState?.fields[ProductRemarksFields.mRemark]?.value]),
            );
            break;
          case 202:
            CustomDialog.errorMessages(id == null ? LocaleKeys.addFailed.tr : LocaleKeys.updateFailed.tr);
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
}
