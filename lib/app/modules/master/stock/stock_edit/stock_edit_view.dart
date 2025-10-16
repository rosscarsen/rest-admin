import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import '../stock_table_fields.dart';
import 'stock_edit_controller.dart';

class StockEditView extends GetView<StockEditController> {
  const StockEditView({super.key});
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
                  name: StockTableFields.mCode,
                  labelText: LocaleKeys.code.tr,
                  enabled: controller.id == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                ),
              ),
              //名称
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: StockTableFields.mName, labelText: LocaleKeys.name.tr),
              ),
              //称谓
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: StockTableFields.mAttn, labelText: LocaleKeys.attn.tr),
              ),
              //电邮
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: StockTableFields.mEmail,
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
              //手机
              FormHelper.buildGridCol(
                child: FormHelper.phoneInput(name: StockTableFields.mPhone, labelText: LocaleKeys.mobile.tr),
              ),
              //传真
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: StockTableFields.mFax, labelText: LocaleKeys.fax.tr),
              ),
              //邮编
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: StockTableFields.mZip, labelText: LocaleKeys.postCode.tr),
              ),

              //非启用
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: StockTableFields.mNon_Active,
                  labelText: LocaleKeys.nonEnable.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //厨房标签
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: StockTableFields.mKitchenLabel,
                  labelText: LocaleKeys.kitchenLabel.tr,
                  initialValue: "0",
                  items: [
                    DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //URL
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: StockTableFields.mFloorplan_PreFix, labelText: "URL"),
              ),
              //参考编号
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: StockTableFields.mRefNo, labelText: LocaleKeys.refCode.tr),
              ),

              //地址
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: StockTableFields.mAddress,
                  labelText: LocaleKeys.address.tr,
                  maxLines: 2,
                ),
              ),

              //备注
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: StockTableFields.mRemarks,
                  labelText: LocaleKeys.remarks.tr,
                  maxLines: 2,
                ),
              ),
              //销售备忘
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: StockTableFields.mSalesMemo_Footer,
                  labelText: LocaleKeys.salesMemoFooter.tr,
                  maxLines: 2,
                ),
              ),
              //銷售備註
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.textInput(
                  name: StockTableFields.mSalesMemo_Remarks,
                  labelText: LocaleKeys.salesMemoRemarks.tr,
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
