import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart' show FormBuilderState, FormBuilder;
import 'package:form_builder_validators/form_builder_validators.dart' show FormBuilderValidators;
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../model/product_remarks_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/file_storage.dart';
import '../../../utils/form_help.dart';
import '../../../utils/logger.dart';
import 'product_remarks_data_source.dart';

class ProductRemarksController extends GetxController {
  final DataGridController dataGridController = DataGridController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> copyKey = GlobalKey<FormBuilderState>();
  static ProductRemarksController get to => Get.find();
  final isLoading = true.obs;
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalRecords = 0.obs;
  List<ProductRemarksInfo> dataList = [];
  final ApiClient apiClient = ApiClient();
  late ProductRemarksDataSource dataSource;
  RxBool hasPermission = true.obs;
  @override
  void onInit() {
    updateDataGridSource();
    super.onInit();
  }

  @override
  void onClose() {
    dataGridController.dispose();
    super.onClose();
  }

  /// 重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages.value = 0;
    currentPage.value = 1;
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    dataGridController.selectedRows = [];
    getList().then((_) {
      dataSource = ProductRemarksDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading(true);
    dataList.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage.value, ...formKey.currentState?.value ?? {}};
      final DioApiResult dioApiResult = await apiClient.post(Config.productRemark, data: param);

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission.value = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      hasPermission.value = true;
      //logger.f(dioApiResult.data);
      final resultModel = productRemarksModelFromJson(dioApiResult.data.toString());
      if (resultModel.status == 200) {
        dataList
          ..clear()
          ..addAll(resultModel.apiResult?.productRemarksInfo ?? []);
        totalPages.value = (resultModel.apiResult?.lastPage ?? 0);
        totalRecords.value = (resultModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading(false);
    }
  }

  /// 编辑
  void edit({int? id}) async {
    Get.toNamed(Routes.PRODUCT_REMARKS_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 删除单行数据
  void deleteRow(int? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.post(Config.productRemarkDelete, data: {"id": id});

          if (!dioApiResult.success) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> data = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;
          switch (data['status']) {
            case 200:
              CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
              dataList.removeWhere((element) => element.mId == id);
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.ftpConnectFailed.tr);
              break;
            default:
              CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
          }
        } catch (e) {
          CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
        } finally {
          CustomDialog.dismissDialog();
        }
      },
    );
  }

  /// 导出
  Future<void> exportProductRemark() async {
    CustomDialog.showLoading(LocaleKeys.generating.trArgs(["excel"]));
    try {
      final DioApiResult dioApiResult = await apiClient.generateExcel(Config.exportProductRemarkExcel);
      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data is Uint8List) {
        FileStorage.saveFileToDownloads(
          bytes: dioApiResult.data as Uint8List,
          fileName: dioApiResult.fileName!,
          fileType: DownloadFileType.Excel,
        );
      }
    } catch (e) {
      logger.i(e);
      CustomDialog.errorMessages(LocaleKeys.generateFileFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 导入产品备注
  Future<void> importProductRemark({required File file, required Map<String, dynamic> query}) async {
    CustomDialog.showLoading(LocaleKeys.importing.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.uploadFile(
        file: file,
        uploadUrl: Config.importProductRemarkExcel,
        extraData: query,
      );

      if (!dioApiResult.success) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.importFailed.tr);
        return;
      }
      reloadData();
      CustomDialog.successMessages(LocaleKeys.importFileSuccess.tr);
    } catch (e) {
      CustomDialog.showToast(LocaleKeys.importFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 复制
  Future<void> copyProductRemark({required ProductRemarksInfo row}) async {
    Get.dialog(
      AlertDialog(
        title: Text(LocaleKeys.copyProductRemarks.tr),
        content: FormBuilder(
          key: copyKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              children: [
                //排序
                FormHelper.textInput(
                  initialValue: row.mSort?.toString() ?? "",
                  name: "mSort",
                  labelText: LocaleKeys.sort.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 0,
                ),
                //隐藏
                FormHelper.checkbox(initialValue: row.mVisible == 0, name: "mVisible", labelText: LocaleKeys.hide.tr),
                //食品备注
                FormHelper.textInput(
                  initialValue: row.mRemark ?? "",
                  name: "m_remark",
                  labelText: LocaleKeys.productRemarks.tr,
                  maxLines: 2,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                    FormBuilderValidators.match(RegExp(r'^[^+]*$'), errorText: LocaleKeys.cannotContain.trArgs(['+'])),
                    FormBuilderValidators.match(RegExp(r'^[^&]*$'), errorText: LocaleKeys.cannotContain.trArgs(['&'])),
                  ]),
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(onPressed: () => Get.closeDialog(), child: Text(LocaleKeys.cancel.tr)),
          ElevatedButton(
            onPressed: () async {
              if (copyKey.currentState?.saveAndValidate() ?? false) {
                CustomDialog.showLoading(LocaleKeys.copying.tr);
                final Map<String, dynamic> data = copyKey.currentState?.value ?? {};
                final Map<String, dynamic> param = {"mId": row.mId, ...data};
                param.forEach((key, value) {
                  if (key == "mVisible") {
                    param[key] = value == "1" ? "0" : "1";
                  }
                });
                try {
                  final DioApiResult dioApiResult = await apiClient.post(Config.productRemarkCopy, data: param);
                  if (!dioApiResult.success) {
                    CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
                    return;
                  }
                  if (dioApiResult.data == null) {
                    CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
                    return;
                  }
                  final Map<String, dynamic> data = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;
                  switch (data["status"]) {
                    case 200:
                      CustomDialog.successMessages(LocaleKeys.copySuccess.tr);
                      final apiResult = data["apiResult"];
                      if (apiResult == null) {
                        return;
                      }
                      final resultModel = ProductRemarksInfo.fromJson(apiResult);
                      dataList.insert(0, resultModel);
                      dataSource.updateDataSource();
                      Get.closeDialog();
                      break;
                    case 201:
                      CustomDialog.errorMessages(
                        LocaleKeys.codeExists.trArgs([copyKey.currentState?.fields["m_remark"]?.value]),
                      );
                      break;
                    case 202:
                      CustomDialog.errorMessages(LocaleKeys.copyFailed.tr);
                      break;
                    default:
                      CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
                  }
                } catch (e) {
                  CustomDialog.errorMessages(LocaleKeys.copyFailed.tr);
                } finally {
                  CustomDialog.dismissDialog();
                }
              }
            },
            child: Text(LocaleKeys.copy.tr),
          ),
        ],
      ),
    );
  }
}
