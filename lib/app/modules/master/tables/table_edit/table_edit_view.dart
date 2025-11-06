import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../model/user/user_data.dart';
import '../../../../routes/app_pages.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import '../../../../widgets/no_record.dart';
import '../tables_table_fields.dart';
import 'table_edit_controller.dart';

class TableEditView extends GetView<TableEditController> {
  const TableEditView({super.key});
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
              //台号
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mTableNo,
                  labelText: LocaleKeys.tableNo.tr,
                  enabled: controller.copy != null || controller.id == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: LocaleKeys.thisFieldIsRequired.tr),
                  ]),
                ),
              ),
              //区域
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: TablesTableFields.mLayer, labelText: LocaleKeys.district.tr),
              ),
              //台名
              FormHelper.buildGridCol(
                child: FormHelper.textInput(name: TablesTableFields.mTableName, labelText: LocaleKeys.tableName.tr),
              ),
              //店铺
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: TablesTableFields.mStockCode,
                  labelText: LocaleKeys.stock.tr,
                  items: controller.allStock
                      .map((e) => DropdownMenuItem(value: e.mCode, child: Text("${e.mCode ?? ''} ${e.mName ?? ''}")))
                      .toList(),
                ),
              ),
              //座位人数
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mMaxNum,
                  labelText: LocaleKeys.seats.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 0,
                ),
              ),
              //最底消费
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mLimitcost,
                  labelText: LocaleKeys.minimumConsumption.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 2,
                ),
              ),
              //服务费
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mServCharge,
                  labelText: LocaleKeys.serviceCharge.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 2,
                  onChanged: (value) => controller.setIsServiceFeeGroupVisible(value),
                ),
              ),
              //折扣
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mDiscount,
                  labelText: LocaleKeys.discount.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 2,
                ),
              ),
              //客户
              FormHelper.buildGridCol(
                child: FormHelper.openInput(
                  name: TablesTableFields.mCustomerCode,
                  labelText: LocaleKeys.customer.tr,
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_CUSTOMER);
                    if (ret != null) {
                      controller.formKey.currentState?.fields[TablesTableFields.mCustomerCode]?.didChange(ret);
                    }
                  },
                ),
              ),
              //服务员
              FormHelper.buildGridCol(
                child: FormHelper.openInput(
                  name: TablesTableFields.mServer,
                  labelText: LocaleKeys.waiter.tr,
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_USER);
                    if (ret != null && ret is UserData) {
                      controller.formKey.currentState?.fields[TablesTableFields.mServer]?.didChange(ret.mName);
                    }
                  },
                ),
              ),
              //模式
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: TablesTableFields.mToGo,
                  labelText: LocaleKeys.mode.tr,
                  items: [
                    DropdownMenuItem(value: '0', child: Text('')),
                    DropdownMenuItem(value: '1', child: Text(LocaleKeys.takeOut.tr)),
                    DropdownMenuItem(value: '2', child: Text(LocaleKeys.dineIn.tr)),
                  ],
                ),
              ),
              //形状
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: TablesTableFields.mShape,
                  labelText: LocaleKeys.shape.tr,
                  items: [
                    DropdownMenuItem(value: '1', child: Text(LocaleKeys.square.tr)),
                    DropdownMenuItem(value: '2', child: Text(LocaleKeys.circle.tr)),
                    DropdownMenuItem(value: '3', child: Text(LocaleKeys.rhombus.tr)),
                  ],
                ),
              ),
              //左边距
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mLeft,
                  labelText: LocaleKeys.leftMargin.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 13,
                ),
              ),
              //上边距
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mTop,
                  labelText: LocaleKeys.topMargin.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 13,
                ),
              ),
              //宽度
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mWidth,
                  labelText: LocaleKeys.width.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 13,
                ),
              ),
              //高度
              FormHelper.buildGridCol(
                child: FormHelper.textInput(
                  name: TablesTableFields.mHeight,
                  labelText: LocaleKeys.height.tr,
                  keyboardType: TextInputType.number,
                  maxDecimalDigits: 13,
                ),
              ),
              //不要颜色
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: TablesTableFields.mNoColor,
                  labelText: LocaleKeys.noColor.tr,
                  items: [
                    DropdownMenuItem(value: '0', child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: '1', child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //类型
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: TablesTableFields.mType,
                  labelText: LocaleKeys.type.tr,
                  items: [
                    DropdownMenuItem(value: '0', child: Text(LocaleKeys.dineIn.tr)),
                    DropdownMenuItem(value: '1', child: Text(LocaleKeys.takeOut.tr)),
                  ],
                ),
              ),
              //数量依人数
              FormHelper.buildGridCol(
                child: FormHelper.selectInput(
                  name: TablesTableFields.mByPerson,
                  labelText: LocaleKeys.qtyByPeople.tr,
                  items: [
                    DropdownMenuItem(value: '0', child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: '1', child: Text(LocaleKeys.yes.tr)),
                  ],
                ),
              ),
              //食品编号
              FormHelper.buildGridCol(
                child: FormHelper.openInput(
                  name: TablesTableFields.mProduct_Code,
                  labelText: LocaleKeys.paramCode.trArgs([LocaleKeys.product.tr]),
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_PRODUCT);
                    if (ret != null) {
                      controller.formKey.currentState?.fields[TablesTableFields.mProduct_Code]?.didChange(ret);
                    }
                  },
                ),
              ),
              //部门
              FormHelper.buildGridCol(
                child: FormHelper.openInput(
                  name: TablesTableFields.mDept,
                  labelText: LocaleKeys.department.tr,
                  onPressed: () async {
                    var ret = await Get.toNamed(Routes.OPEN_DEPARTMENT);
                    if (ret != null) {
                      controller.formKey.currentState?.fields[TablesTableFields.mDept]?.didChange(ret);
                    }
                  },
                ),
              ),
              FormHelper.line(),
              //服务费 开始时段
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  name: TablesTableFields.mDateTimeStart,
                  labelText: LocaleKeys.serviceFeeStartTime.tr,
                  inputType: DateInputType.time,
                ),
              ),
              //服务费 结束时段
              FormHelper.buildGridCol(
                child: FormHelper.dateInput(
                  name: TablesTableFields.mDateTimeEnd,
                  labelText: LocaleKeys.serviceFeeEndTime.tr,
                  inputType: DateInputType.time,
                ),
              ),
              FormHelper.buildGridCol(
                sm: 12,
                md: 12,
                lg: 12,
                xl: 12,
                child: FormHelper.buildGridRow(
                  children: [
                    //星期一
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day1,
                        labelText: LocaleKeys.mon.tr,
                        showBorder: true,
                      ),
                    ),
                    //星期二
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day2,
                        labelText: LocaleKeys.tue.tr,
                        showBorder: true,
                      ),
                    ),
                    //星期三
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day3,
                        labelText: LocaleKeys.wed.tr,
                        showBorder: true,
                      ),
                    ),
                    //星期四
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day4,
                        labelText: LocaleKeys.thu.tr,
                        showBorder: true,
                      ),
                    ),
                    //星期五
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day5,
                        labelText: LocaleKeys.fri.tr,
                        showBorder: true,
                      ),
                    ),
                    //星期六
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day6,
                        labelText: LocaleKeys.sat.tr,
                        showBorder: true,
                      ),
                    ),
                    //星期日
                    FormHelper.buildGridCol(
                      child: FormHelper.checkbox(
                        name: TablesTableFields.day7,
                        labelText: LocaleKeys.sun.tr,
                        showBorder: true,
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
