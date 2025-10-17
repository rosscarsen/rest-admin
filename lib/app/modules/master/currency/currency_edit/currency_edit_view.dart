import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import '../currency_table_fields.dart';
import 'currency_edit_controller.dart';

class CurrencyEditView extends GetView<CurrencyEditController> {
  const CurrencyEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          centerTitle: true,
          actions: controller.isLoading
              ? null
              : [
                  Tooltip(
                    message: LocaleKeys.refresh.tr,
                    child: IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.refreshData()),
                  ),
                ],
        ),

        body: controller.hasPermission ? _buildMain() : NoRecordPermission(msg: LocaleKeys.noPermission.tr),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: controller.isLoading || !controller.hasPermission ? null : () => controller.save(),
          ),
        ],
      ),
    );
  }

  /// 构建表单
  Widget _buildMain() {
    return Skeletonizer(
      enabled: controller.isLoading,
      child: FormBuilder(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: FormHelper.buildGridRow(
            children: [
              //编号
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: CurrencyTableFields.mCode,
                  labelText: LocaleKeys.code.tr,
                  enabled: controller.id == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                ),
              ),
              //兑换率
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: CurrencyTableFields.mRate,
                  labelText: LocaleKeys.rate.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 4,
                ),
              ),
              //设为默认
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: CurrencyTableFields.mDefault,
                  labelText: LocaleKeys.defaultSelect.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),

              //描述
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: CurrencyTableFields.mDescription,
                  labelText: LocaleKeys.description.tr,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
