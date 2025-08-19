import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import 'category_edit_controller.dart';
import 'category_fields.dart';

class CategoryEditView extends GetView<CategoryEditController> {
  const CategoryEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.title.value),
          centerTitle: true,
          actions: controller.isLoading.value
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
          FormHelper.button(
            onPressed: controller.isLoading.value || !controller.hasPermission.value ? null : () => controller.save(),
          ),
        ],
      ),
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
          child: ResponsiveGridRow(
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
              //描述
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: CategoryFields.mDescription, labelText: LocaleKeys.description.tr),
              ),
              //层数
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "1",
                  name: CategoryFields.tier,
                  labelText: LocaleKeys.layer.tr,
                  items: List.generate(3, (index) {
                    final value = ((index * 2) + 1).toString();
                    return DropdownMenuItem(value: value, child: Text(value));
                  }),
                ),
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
              //停用
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
              //客戶自助隐藏
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "1",
                  name: CategoryFields.mCustomer_self_help_Hide,
                  labelText: LocaleKeys.customerHide.tr,
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //外卖隐藏
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "1",
                  name: CategoryFields.mTakeaway_display,
                  labelText: LocaleKeys.takeawayHide.tr,
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //Kiosk 隐藏
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  initialValue: "0",
                  name: CategoryFields.mKiosk,
                  labelText: LocaleKeys.kiosk.tr,
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
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
