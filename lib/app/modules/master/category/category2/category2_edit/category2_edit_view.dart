import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../translations/locale_keys.dart';
import '../../../../../utils/form_help.dart';
import '../../../../../widgets/no_record.dart';
import '../../category_edit/category_fields.dart';
import 'category2_edit_controller.dart';

class Category2EditView extends GetView<Category2EditController> {
  final int? id;
  final String? category1;
  const Category2EditView({super.key, this.id, this.category1});
  @override
  Widget build(BuildContext context) {
    return GetX<Category2EditController>(
      init: Category2EditController(id: id),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.title.value),
            centerTitle: true,
            actions: (controller.isLoading.value || !controller.hasPermission.value)
                ? null
                : [
                    Tooltip(
                      message: LocaleKeys.refresh.tr,
                      child: IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.refreshData()),
                    ),
                  ],
          ),

          body: controller.hasPermission.value ? _buildMain() : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
          persistentFooterButtons: [
            FormHelper.saveButton(
              onPressed: controller.isLoading.value || !controller.hasPermission.value ? null : () => controller.save(),
            ),
          ],
        );
      },
    );
  }

  /// 构建表单
  Widget _buildMain() {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: FormBuilder(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FormHelper.buildGridRow(
            children: [
              //类目
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: CategoryFields.mCategory,
                  labelText: LocaleKeys.category.tr,
                  enabled: controller.id == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                ),
              ),
              //父类目
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  initialValue: category1,
                  name: CategoryFields.mParent,
                  labelText: LocaleKeys.parentCategory.tr,
                  enabled: false,
                ),
              ),
              //描述
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: CategoryFields.mDescription, labelText: LocaleKeys.description.tr),
              ),
              //排序
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: CategoryFields.mSort,
                  labelText: LocaleKeys.sort.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 0,
                ),
              ),
              //折扣(0-100)
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: CategoryFields.mDiscount,
                  labelText: "${LocaleKeys.discount.tr} (0-100)",
                  keyboardType: TextInputType.number,
                ),
              ),
              //开始时段
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  name: CategoryFields.mTimeStart,
                  labelText: LocaleKeys.startTime.tr,
                  inputType: DateInputType.time,
                  initialValue: "00:00",
                ),
              ),
              //结束时段
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  initialValue: "23:59",
                  name: CategoryFields.mTimeEnd,
                  labelText: LocaleKeys.endTime.tr,
                  inputType: DateInputType.time,
                ),
              ),
              //隐藏
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "0",
                  name: CategoryFields.mHide,
                  labelText: LocaleKeys.deactivate.tr,
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //打印类型
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "0",
                  name: CategoryFields.mPrintType,
                  labelText: LocaleKeys.printType.tr,
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.general.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.takeaway.tr)),
                  ],
                ),
              ),
              //客戶自助隐藏
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "0",
                  name: CategoryFields.mCustomer_self_help_Hide,
                  labelText: LocaleKeys.customerHide.tr,
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //厨房/水吧打印机
              FormHelper.buildGridCol(
                child: Row(
                  children: [
                    Expanded(
                      child: FormHelper.selectInput(
                        name: CategoryFields.mPrinter,
                        labelText: LocaleKeys.kitchenBarPrinter.tr,
                        items: [
                          DropdownMenuItem(value: "", child: Text("")),
                          ...controller.printerList.map(
                            (e) => DropdownMenuItem(
                              value: e.mName,
                              child: FittedBox(child: Text(e.mName ?? "")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    //连续打印
                    Expanded(
                      child: FormHelper.checkbox(
                        initialValue: false,
                        name: CategoryFields.mContinue,
                        labelText: LocaleKeys.continuePrint.tr,
                      ),
                    ),
                  ],
                ),
              ),
              //班地尼打印机
              FormHelper.buildGridCol(
                child: Row(
                  children: [
                    Expanded(
                      child: FormHelper.selectInput(
                        name: CategoryFields.mBDLPrinter,
                        labelText: LocaleKeys.BDLPrinter.tr,
                        items: [
                          DropdownMenuItem(value: "", child: Text("")),
                          ...controller.printerList.map(
                            (e) => DropdownMenuItem(
                              value: e.mName,
                              child: FittedBox(child: Text(e.mName ?? "")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    //连续打印
                    Expanded(
                      child: FormHelper.checkbox(
                        initialValue: false,
                        name: CategoryFields.mNonContinue,
                        labelText: LocaleKeys.disContinuePrint.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
