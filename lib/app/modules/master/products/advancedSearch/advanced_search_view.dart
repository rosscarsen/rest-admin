import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config.dart';
import '../../../../model/supplier/supplier_data.dart';
import '../../../../routes/app_pages.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/form_help.dart';
import 'advanced_search_controller.dart';
import 'advanced_search_fields.dart';

class AdvancedSearchView extends GetView<AdvancedSearchController> {
  const AdvancedSearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.advancedSearch.tr), centerTitle: true),
        body: Padding(
          padding: EdgeInsets.all(Config.defaultPadding),
          child: Skeletonizer(
            enabled: controller.isLoading.value,
            child: FormBuilder(key: controller.formKey, child: _buildSearchForm()),
          ),
        ),
        persistentFooterButtons: [
          FormHelper.saveButton(
            onPressed: () {
              //controller.formKey.currentState?.fields[AdvancedSearchFields.mCategory1]?.didChange("40000");
              if (controller.formKey.currentState?.enabled == false) return;
              if (controller.formKey.currentState?.saveAndValidate() ?? false) {
                final Map<String, dynamic> formData = controller.formKey.currentState!.value;
                Get.back(result: formData);
              } else {
                return;
              }
            },
            label: LocaleKeys.search.tr,
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
      ),
    );
  }

  // Search form
  SingleChildScrollView _buildSearchForm() {
    return SingleChildScrollView(
      child: FormHelper.buildGridRow(
        children: [
          //类目1
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mCategory1,
              labelText: "${LocaleKeys.category.tr}1",
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                if (controller.category1.isNotEmpty)
                  ...controller.category1.map(
                    (e) => DropdownMenuItem(
                      value: e.mCategory.toString(),
                      child: Row(
                        spacing: 8.0,
                        children: [
                          Text(e.mCategory.toString()),
                          Flexible(child: Text(e.mDescription.toString())),
                        ],
                      ),
                    ),
                  ),
              ],
              onChanged: (String? category1) {
                controller.generateCategory2(category1);
              },
            ),
          ),
          //类目2
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mCategory2,
              labelText: "${LocaleKeys.category.tr}2",
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                if (controller.category2.isNotEmpty)
                  ...controller.category2.map(
                    (e) => DropdownMenuItem(
                      value: e.mCategory,
                      child: Row(
                        spacing: 8.0,
                        children: [
                          Text(e.mCategory.toString()),
                          Flexible(child: Text(e.mDescription.toString())),
                        ],
                      ),
                    ),
                  ),
              ],
              onChanged: (String? category2) {
                controller.generateCategory3(category2);
              },
            ),
          ),
          //类目3
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mCategory3,
              labelText: "${LocaleKeys.category.tr}3",
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                if (controller.category3.isNotEmpty)
                  ...controller.category3.map(
                    (e) => DropdownMenuItem(
                      value: e.mCategory,
                      child: Row(
                        spacing: 8.0,
                        children: [
                          Text(e.mCategory.toString()),
                          Flexible(child: Text(e.mDescription.toString())),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          //编号
          FormHelper.buildGridCol(
            child: FormHelper.openInput(
              name: AdvancedSearchFields.mCode,
              labelText: LocaleKeys.code.tr,
              onPressed: () async {
                var result = await Get.toNamed(Routes.OPEN_PRODUCT);
                controller.formKey.currentState?.fields[AdvancedSearchFields.mCode]?.didChange(result);
              },
            ),
          ),
          //条形码
          FormHelper.buildGridCol(
            child: FormHelper.textInput(name: AdvancedSearchFields.mBarcode, labelText: LocaleKeys.barcode.tr),
          ),
          //开始编号
          FormHelper.buildGridCol(
            child: FormHelper.openInput(
              name: AdvancedSearchFields.startNo,
              labelText: LocaleKeys.startCode.tr,
              onPressed: () async {
                var result = await Get.toNamed(Routes.OPEN_PRODUCT);
                controller.formKey.currentState?.fields[AdvancedSearchFields.startNo]?.didChange(result);
              },
            ),
          ),
          //结束编号
          FormHelper.buildGridCol(
            child: FormHelper.openInput(
              name: AdvancedSearchFields.endNo,
              labelText: LocaleKeys.endCode.tr,
              onPressed: () async {
                var result = await Get.toNamed(Routes.OPEN_PRODUCT);
                controller.formKey.currentState?.fields[AdvancedSearchFields.endNo]?.didChange(result);
              },
            ),
          ),
          //名称
          FormHelper.buildGridCol(
            child: FormHelper.textInput(name: AdvancedSearchFields.mDesc1, labelText: LocaleKeys.name.tr),
          ),
          //厨房单
          FormHelper.buildGridCol(
            child: FormHelper.textInput(name: AdvancedSearchFields.mDesc2, labelText: LocaleKeys.kitchenList.tr),
          ),
          //参考编号
          FormHelper.buildGridCol(
            child: FormHelper.textInput(name: AdvancedSearchFields.mRefCode, labelText: LocaleKeys.refCode.tr),
          ),
          //供应商
          FormHelper.buildGridCol(
            child: FormHelper.openInput(
              name: AdvancedSearchFields.mSupplierCode,
              labelText: LocaleKeys.supplier.tr,
              onPressed: () async {
                var result = await Get.toNamed(Routes.OPEN_SUPPLIER);
                if (result != null && result is SupplierData) {
                  controller.formKey.currentState?.fields[AdvancedSearchFields.mSupplierCode]?.didChange(
                    result.mCode ?? "",
                  );
                }
              },
            ),
          ),

          //部门
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mBrand,
              labelText: LocaleKeys.department.tr,
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                if (controller.department.isNotEmpty)
                  ...controller.department.map(
                    (e) => DropdownMenuItem(value: e.mBrand.toString(), child: Text(e.mBrand.toString())),
                  ),
              ],
            ),
          ),
          /*  //开始日期
          FormHelper.dateInput(name: AdvancedSearchFields.dateStart, labelText: LocaleKeys.startDate.tr),
          //结束日期
          FormHelper.dateInput(name: AdvancedSearchFields.dateEnd, labelText: LocaleKeys.endDate.tr), */
          //非启用
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mNonActived,
              labelText: LocaleKeys.nonEnable.tr,
              initialValue: "0",
              items: [
                DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
          ),
          //非库存
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mNonStock,
              labelText: LocaleKeys.nonStock.tr,
              initialValue: "",
              items: [
                DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
          ),
          //创建开始日期
          FormHelper.buildGridCol(
            child: FormHelper.dateInput(
              name: AdvancedSearchFields.startDateCreate,
              labelText: LocaleKeys.startCreateDate.tr,
            ),
          ),
          //创建结束日期
          FormHelper.buildGridCol(
            child: FormHelper.dateInput(
              name: AdvancedSearchFields.endDateCreate,
              labelText: LocaleKeys.endCreateDate.tr,
            ),
          ),
          //不具折上折
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mNonDiscount,
              labelText: LocaleKeys.notDiscount.tr,
              initialValue: "",

              items: [
                DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
          ),
          //预支付
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mPrePaid,
              labelText: LocaleKeys.prePaid.tr,
              initialValue: "",
              items: [
                DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
          ),
          //开始修改日期
          FormHelper.buildGridCol(
            child: FormHelper.dateInput(
              name: AdvancedSearchFields.startDateModify,
              labelText: LocaleKeys.startModifyDate.tr,
            ),
          ),
          //结束修改日期
          FormHelper.buildGridCol(
            child: FormHelper.dateInput(
              name: AdvancedSearchFields.endDateModify,
              labelText: LocaleKeys.endModifyDate.tr,
            ),
          ),
          //套餐产品编号
          FormHelper.buildGridCol(
            child: FormHelper.textInput(
              name: AdvancedSearchFields.setMealCode,
              labelText: LocaleKeys.setMealProductCode.tr,
            ),
          ),
          //套餐
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.setMenu,
              labelText: LocaleKeys.setMeal.tr,
              initialValue: "",
              items: [
                DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
          ),
          //售罄
          FormHelper.buildGridCol(
            child: FormHelper.selectInput(
              name: AdvancedSearchFields.mSoldOut,
              labelText: LocaleKeys.soldOut.tr,
              initialValue: "",
              items: [
                DropdownMenuItem(value: "", child: Text(LocaleKeys.all.tr)),
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
