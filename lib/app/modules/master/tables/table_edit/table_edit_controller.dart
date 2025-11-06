import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../../config.dart';
import '../../../../mixin/loading_state_mixin.dart';
import '../../../../model/stock/stock_data.dart';
import '../../../../model/tables/tables_data.dart';
import '../../../../model/tables/tables_edit_model.dart';
import '../../../../service/dio_api_client.dart';
import '../../../../service/dio_api_result.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/storage_manage.dart';
import '../tables_controller.dart';
import '../tables_table_fields.dart';

class TableEditController extends GetxController with LoadingStateMixin<TablesData> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final StorageManage storageManage = StorageManage();

  /// Dio客户端
  final ApiClient apiClient = ApiClient();

  String? id;
  String? copy;
  List<StockData> allStock = [];
  //编辑前的数据
  TablesData? oldRow;
  @override
  void onInit() {
    super.onInit();
    title = LocaleKeys.addParam.trArgs([LocaleKeys.tables.tr]);
    final params = Get.parameters;
    if (params.isNotEmpty) {
      id = params['id'];
      if (id != null) {
        title = LocaleKeys.editParam.trArgs([LocaleKeys.tables.tr]);
        copy = params['copy'];
        if (copy != null) {
          title = LocaleKeys.copyParam.trArgs([LocaleKeys.tables.tr]);
        }
      }
    }
    addOrEdit();
  }

  /// 服务费用组是否可见
  void setIsServiceFeeGroupVisible(Object? value) {
    String raw = Functions.asString(value);
    if (raw.isEmpty) {
      raw = "0";
    }
    num serviceFee = num.tryParse(raw) ?? 0;
    if (serviceFee > 0) {
      formKey.currentState?.patchValue({
        TablesTableFields.mDateTimeStart: "00:00",
        TablesTableFields.mDateTimeEnd: "23:59",
        TablesTableFields.day1: true,
        TablesTableFields.day2: true,
        TablesTableFields.day3: true,
        TablesTableFields.day4: true,
        TablesTableFields.day5: true,
        TablesTableFields.day6: true,
        TablesTableFields.day7: true,
      });
    } else {
      formKey.currentState?.patchValue({
        TablesTableFields.mDateTimeStart: null,
        TablesTableFields.mDateTimeEnd: null,
        TablesTableFields.day1: false,
        TablesTableFields.day2: false,
        TablesTableFields.day3: false,
        TablesTableFields.day4: false,
        TablesTableFields.day5: false,
        TablesTableFields.day6: false,
        TablesTableFields.day7: false,
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    oldRow = null;
    allStock.clear();
    super.onClose();
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await addOrEdit();
  }

  /// 添加或编辑
  Future<void> addOrEdit() async {
    isLoading = true;
    data = null;
    oldRow = null;
    try {
      final DioApiResult dioApiResult = await apiClient.get(Config.tablesAddOrEdit, data: {'id': id});
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

      final resultModel = tablesEditModelFromJson(dioApiResult.data);

      if (resultModel.status == 200 && resultModel.apiResult != null) {
        final TablesEditResult? ret = resultModel.apiResult;
        allStock
          ..clear()
          ..addAll(ret?.allStock ?? []);
        final tablesData = ret?.toJson() ?? {};
        tablesData.remove("allStock");
        oldRow = data = TablesData.fromJson(tablesData);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          formKey.currentState?.fields[TablesTableFields.mStockCode]?.didChange(allStock.first.mCode ?? "");
          final jsonMap = Map<String, dynamic>.from(data?.toJson() ?? {});
          final filteredMap = Map.fromEntries(
            jsonMap.entries
                .where((e) => (e.value?.toString() ?? "").trim().isNotEmpty)
                .map((e) => MapEntry(e.key, e.value is PhoneNumber || e.value is bool ? e.value : e.value.toString())),
          );
          if (copy != null) {
            filteredMap.remove(TablesTableFields.mTableNo);
          }
          logger.f(filteredMap);
          formKey.currentState?.patchValue(filteredMap);
          filteredMap.clear();
        });
      }
    } catch (e) {
      CustomDialog.errorMessages(LocaleKeys.getDataException.tr);
    } finally {
      isLoading = false;
    }
  }

  /// 保存
  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final preCtl = Get.find<TablesController>();
      final formData = formKey.currentState?.value ?? {};

      //如果是编辑检测一下数据是否有变化
      if (id != null) {
        final dayFields = {
          TablesTableFields.day1,
          TablesTableFields.day2,
          TablesTableFields.day3,
          TablesTableFields.day4,
          TablesTableFields.day5,
          TablesTableFields.day6,
          TablesTableFields.day7,
        };
        final oldJson = Map.fromEntries(
          (oldRow?.toJson() ?? {}).entries.map((e) {
            final key = e.key;
            var value = e.value;
            // 处理 PhoneNumber
            if (value is PhoneNumber) {
              value = value.nsn.isNotEmpty ? '+${value.countryCode}${value.nsn}' : '';
            }
            // 处理布尔 day 字段
            else if (dayFields.contains(key) && value is bool) {
              value = value ? '1' : '0';
            }
            // 其他类型统一转为字符串（保留 null）
            else if (value != null) {
              value = value.toString();
            }

            return MapEntry(key, value);
          }),
        );

        final isSame = Functions.compareMap(oldJson, formData);

        if (isSame) {
          Get.back();
          return;
        }
      }
      //发送网络保存请求
      CustomDialog.showLoading(LocaleKeys.saving.tr);
      final requestData = {...formData, "id": id};
      if (copy != null) {
        requestData.remove("id");
      }
      try {
        final DioApiResult dioApiResult = await apiClient.post(Config.tablesSave, data: requestData);
        logger.f(dioApiResult);
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
              preCtl.reloadData();
              Get.back();
              return;
            }
            final resultModel = TablesData.fromJson(apiResult);
            final preData = preCtl.data;
            if (copy != null) {
              preData?.insert(0, resultModel);
            } else {
              if (id == null) {
                preData?.insert(0, resultModel);
              } else {
                final index = preCtl.data?.indexWhere((element) => element.mId.toString() == id) ?? -1;
                if (index != -1) {
                  preData?[index] = resultModel;
                }
              }
            }
            preCtl.dataSource.updateDataSource();
            Get.back();
            break;
          case 201:
            CustomDialog.errorMessages(LocaleKeys.codeExists.trArgs([LocaleKeys.code.tr]));
            break;
          case 202:
            CustomDialog.errorMessages(LocaleKeys.saveFailed.tr);
            break;
          default:
            CustomDialog.errorMessages(LocaleKeys.unknownError.tr);
        }
      } catch (e) {
        CustomDialog.errorMessages(e.toString());
      } finally {
        requestData.clear();
        CustomDialog.dismissDialog();
      }
    }
  }
}
