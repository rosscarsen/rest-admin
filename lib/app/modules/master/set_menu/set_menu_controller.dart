import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../mixin/loading_state_mixin.dart';
import '../../../model/set_meal/set_meal_data.dart';
import '../../../model/set_meal/set_meal_page_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/dio_api_client.dart';
import '../../../service/dio_api_result.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/custom_alert.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/file_storage.dart';
import '../../../utils/form_help.dart';
import '../../../utils/logger.dart';

import 'set_meal_data_source.dart';

class SetMenuController extends GetxController with LoadingStateMixin<List<SetMealData>?> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> copyFormKey = GlobalKey<FormBuilderState>();
  final ApiClient apiClient = ApiClient();
  late SetMealDataSource dataSource;
  @override
  void onInit() {
    super.onInit();
    updateDataGridSource();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 重载数据
  void reloadData() {
    FocusManager.instance.primaryFocus?.unfocus();
    totalPages = 0;
    currentPage = 1;
    updateDataGridSource();
  }

  /// 更新数据源
  void updateDataGridSource() {
    getList().then((_) {
      dataSource = SetMealDataSource(this);
    });
  }

  /// 获取列表
  Future<void> getList() async {
    isLoading = true;
    data?.clear();
    try {
      formKey.currentState?.saveAndValidate();
      final param = {'page': currentPage, ...formKey.currentState?.value ?? {}};
      final DioApiResult dioApiResult = await apiClient.get(Config.setMenu, data: param);

      if (!dioApiResult.success) {
        if (!dioApiResult.hasPermission) {
          hasPermission = false;
        }
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (dioApiResult.data == null) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      hasPermission = true;

      final resultModel = setMealPageModelFromJson(dioApiResult.data.toString());
      if (resultModel.status == 200) {
        data = resultModel.apiResult?.data ?? [];
        totalPages = (resultModel.apiResult?.lastPage ?? 0);
        totalRecords = (resultModel.apiResult?.total ?? 0);
      } else {
        CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
      }
    } finally {
      isLoading = false;
    }
  }

  /// 编辑
  void edit({String? id}) async {
    Get.toNamed(Routes.SET_MENU_EDIT, parameters: id == null ? null : {'id': id.toString()});
  }

  /// 复制
  void copy({String? id}) {
    if (id == null) {
      CustomDialog.showToast(LocaleKeys.exception.tr);
      return;
    }
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text(LocaleKeys.copyParam.trArgs([LocaleKeys.setMeal.tr])),
        content: FormBuilder(
          key: copyFormKey,
          child: FormHelper.textInput(
            name: "code",
            labelText: LocaleKeys.code.tr,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return LocaleKeys.thisFieldIsRequired.tr;
              }
              return null;
            },
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.closeDialog();
            },
            child: Text(LocaleKeys.cancel.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (copyFormKey.currentState?.saveAndValidate() ?? false) {
                final copyFormData = Map<String, dynamic>.from(copyFormKey.currentState?.value ?? {})..["id"] = id;
                try {
                  CustomDialog.showLoading(LocaleKeys.copying.tr);
                  final DioApiResult dioApiResult = await apiClient.post(Config.setMenuCopy, data: copyFormData);
                  if (!dioApiResult.success) {
                    CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
                    return;
                  }
                  if (dioApiResult.data == null) {
                    CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
                    return;
                  }
                  final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
                  switch (data["status"]) {
                    case 200:
                      CustomDialog.successMessages(LocaleKeys.copySuccess.tr);
                      reloadData();
                      break;
                    case 201:
                      CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([copyFormData["copyCode"]]));
                      break;
                    default:
                      CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
                      break;
                  }
                } catch (e) {
                  CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
                } finally {
                  Get.closeDialog();
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

  /// 更新
  void updateSetMeal(SetMealData row) async {
    final TextEditingController productCodesCtl = TextEditingController();
    Get.defaultDialog(
      barrierDismissible: false,
      title: "${LocaleKeys.paramCode.trArgs([LocaleKeys.setMeal.tr])}: ${row.mCode ?? ""}",
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SingleChildScrollView(
            child: Column(
              spacing: 20.0,
              children: <Widget>[
                Text(LocaleKeys.updateOtherProduct.tr),
                FormHelper.openInput(
                  name: "productCodes",
                  controller: productCodesCtl,
                  labelText: LocaleKeys.product.tr,
                  maxLines: 3,
                  onPressed: () async {
                    var ret = await Get.toNamed(
                      Routes.OPEN_MULTIPLE_PRODUCT,
                      parameters: {'productCodes': productCodesCtl.text},
                    );
                    if (ret != null) {
                      final csvString = productCodesCtl.text.isNotEmpty ? "${productCodesCtl.text},$ret" : ret;
                      productCodesCtl.text = csvString.toString().split(",").toSet().join(",");
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      cancel: ElevatedButton(
        onPressed: () {
          productCodesCtl.dispose();
          Get.closeDialog();
        },
        child: Text(LocaleKeys.close.tr),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          productCodesCtl.dispose();
          Get.closeDialog();
          await updateSetMealApi(
            query: {'T_setmenu_ID': row.tSetmenuId, 'setmenu_code': row.mCode, 'productCodes': productCodesCtl.text},
          );
        },
        child: Text(LocaleKeys.update.tr),
      ),
    );
  }

  //执行更新套餐
  Future<void> updateSetMealApi({required Map<String, dynamic> query}) async {
    try {
      CustomDialog.showLoading(LocaleKeys.updating.tr);
      final DioApiResult dioApiResult = await apiClient.post(Config.updateProductSetMeal, data: query);
      if (dioApiResult.success) {
        final data = jsonDecode(dioApiResult.data) as Map<String, dynamic>;
        switch (data["status"]) {
          case 200:
            CustomDialog.successMessages(LocaleKeys.updateSuccess.tr);
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.dataIsEmptyDoNotOperation.tr);
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.updateFailed.tr);
            break;
        }
      } else {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.operationFailed.tr);
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.operationFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }

  /// 删除单行数据
  void deleteRow(String? id) async {
    CustomAlert.iosAlert(
      showCancel: true,
      message: LocaleKeys.deleteConfirmMsg.tr,
      onConfirm: () async {
        try {
          CustomDialog.showLoading(LocaleKeys.deleting.tr);
          final DioApiResult dioApiResult = await apiClient.get(Config.setMenuDelete, data: {"id": id});

          if (!dioApiResult.success) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          if (dioApiResult.data == null) {
            CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
            return;
          }
          final Map<String, dynamic> apiData = jsonDecode(dioApiResult.data!) as Map<String, dynamic>;
          switch (apiData['status']) {
            case 200:
              CustomDialog.successMessages(LocaleKeys.deleteSuccess.tr);
              data?.removeWhere((element) => element.tSetmenuId == id);
              dataSource.updateDataSource();
              break;
            case 201:
              CustomDialog.errorMessages(LocaleKeys.deleteFailed.tr);
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
  Future<void> export({required Map<String, dynamic> query}) async {
    CustomDialog.showLoading(LocaleKeys.generating.trArgs(["excel"]));
    logger.f(query);

    try {
      final DioApiResult dioApiResult = await apiClient.generateExcel(
        Config.exportSetMealExcel,
        queryParameters: query,
      );
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

  /// 导入
  Future<void> import({required File file, required Map<String, dynamic> query}) async {
    CustomDialog.showLoading(LocaleKeys.importing.tr);
    try {
      final DioApiResult dioApiResult = await apiClient.uploadFile(
        file: file,
        uploadUrl: Config.importSetMenu,
        extraData: query,
      );
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.importFailed.tr);
        return;
      }
      reloadData();
      CustomDialog.successMessages(LocaleKeys.importFileSuccess.tr);
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.importFailed.tr);
    } finally {
      CustomDialog.dismissDialog();
    }
  }
}
