import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import '../supplier_table_fields.dart';
import 'supplier_edit_controller.dart';

class SupplierEditView extends GetView<SupplierEditController> {
  const SupplierEditView({super.key});
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
                  name: SupplierTableFields.mCode,
                  labelText: LocaleKeys.code.tr,
                  enabled: controller.id == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                ),
              ),
              //简称
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: SupplierTableFields.mSimpleName, labelText: LocaleKeys.simpleName.tr),
              ),
              //非启用
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: SupplierTableFields.mNon_Active,
                  labelText: LocaleKeys.nonEnable.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //全称
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(name: SupplierTableFields.mFullName, labelText: LocaleKeys.fullName.tr),
              ),
              //地址
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: SupplierTableFields.mAddress,
                  labelText: LocaleKeys.address.tr,
                  maxLines: 2,
                ),
              ),
              //手机
              FormHelper.buildGridCol(
                child: FormHelper.phoneInput(name: SupplierTableFields.mPhone_No, labelText: LocaleKeys.mobile.tr),
              ),
              //传真
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: SupplierTableFields.mFax_No, labelText: LocaleKeys.fax.tr),
              ),
              //联络人
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: SupplierTableFields.mContact, labelText: LocaleKeys.contact.tr),
              ),
              //电邮
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierTableFields.mEmail,
                  labelText: LocaleKeys.email.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    (val) {
                      if (val == null || val.isEmpty) return null;
                      return FormBuilderValidators.email(errorText: LocaleKeys.pleaseEnterAValidEmailAddress.tr)(val);
                    },
                  ]),
                ),
              ),
              FormHelper.line(),
              //货币
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: SupplierTableFields.mST_Currency,
                  labelText: LocaleKeys.currency.tr,
                  items: (controller.data?.currency ?? [])
                      .map((e) => DropdownMenuItem(value: e.mCode, child: Text(e.mDescription ?? "")))
                      .toList(),
                ),
              ),
              //折扣(0-100)
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierTableFields.mST_Discount,
                  labelText: "${LocaleKeys.discount.tr}(0-100)",
                  initialValue: "0",
                  maxDecimalDigits: 2,
                  keyboardType: TextInputType.number,
                ),
              ),
              //支付条款
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierTableFields.mST_Payment_Term,
                  labelText: LocaleKeys.paymentTerm.tr,
                ),
              ),
              //支付日数
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: SupplierTableFields.mST_Payment_Days,
                  labelText: LocaleKeys.paymentDay.tr,
                  initialValue: "0",
                  maxDecimalDigits: 0,
                  keyboardType: TextInputType.number,
                ),
              ),
              //支付方式
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: SupplierTableFields.mST_Payment_Method,
                  labelText: LocaleKeys.paymentMethod.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.actualDay.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.monthly.tr)),
                  ],
                ),
              ),
              FormHelper.line(),
              //备注
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: SupplierTableFields.mRemarks,
                  labelText: LocaleKeys.remarks.tr,
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
