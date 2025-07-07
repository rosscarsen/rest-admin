import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../routes/app_pages.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/form_help.dart';
import 'product_edit_controller.dart';
import 'product_edit_fields.dart';

class ProductEditView extends GetView<ProductEditController> {
  const ProductEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Skeletonizer(
        enabled: controller.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            title: Text(controller.title.value),
            centerTitle: true,
            actions: [
              Tooltip(
                message: LocaleKeys.refresh.tr,
                child: IconButton(
                  onPressed: () {
                    controller.productAddOrEdit();
                  },
                  icon: FaIcon(Icons.refresh),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  isScrollable: true,
                  controller: controller.tabController,
                  tabs: controller.tabs,
                  labelColor: Colors.blueAccent,
                  indicatorColor: Colors.blueAccent,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.grey.shade600,
                  overlayColor: WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
                  tabAlignment: TabAlignment.start,
                ),
              ),
            ),
          ),
          body: _buildTabBarView(),

          persistentFooterButtons: [
            FormHelper.button(
              onPressed: () {
                if (controller.formKey.currentState?.saveAndValidate() ?? false) {
                  debugPrint(controller.formKey.currentState?.value.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // tabBarView
  Widget _buildTabBarView() {
    return FormBuilder(
      key: controller.formKey,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          _buildProduct(),
          _buildDetail(),
          _buildBarcode(),
          _buildShop(),
          if (Get.parameters.isNotEmpty) _buildSetMealLimit(),
          if (Get.parameters.isNotEmpty) _buildSetMeal(),
        ],
      ),
    );
  }

  // 产品实图
  Widget _buildProduct() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ResponsiveGridRow(
          children: [
            //类目1
            FormHelper.selectInput(
              name: ProductEditFields.mCategory1,
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
            //类目2
            FormHelper.selectInput(
              name: ProductEditFields.mCategory2,
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
            ),
            //创建日期
            FormHelper.dateInput(
              name: ProductEditFields.mDate_Create,
              labelText: LocaleKeys.createDate.tr,
              enabled: false,
              inputType: DateInputType.dateAndTime,
              canClear: false,
            ),
            //编号
            FormHelper.textInput(
              name: ProductEditFields.mCode,
              labelText: LocaleKeys.code.tr,
              enabled: Get.parameters.isEmpty,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return LocaleKeys.thisFieldIsRequired.tr;
                }
                return null;
              },
            ),
            //价钱1
            FormHelper.textInput(
              name: ProductEditFields.mPrice,
              labelText: "${LocaleKeys.price.tr}1",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  try {
                    final text = newValue.text;
                    if (text.isEmpty) return newValue;
                    double.parse(text);
                    return newValue;
                  } catch (_) {
                    return oldValue;
                  }
                }),
              ],
            ),
            //修改日期
            FormHelper.dateInput(
              name: ProductEditFields.mDate_Modify,
              labelText: LocaleKeys.modifyDate.tr,
              enabled: false,
              inputType: DateInputType.dateAndTime,
              canClear: false,
            ),
            //名称
            FormHelper.textInput(name: ProductEditFields.mDesc1, labelText: LocaleKeys.name.tr, maxLines: 2),
            //厨房单
            FormHelper.textInput(name: ProductEditFields.mDesc2, labelText: LocaleKeys.kitchenList.tr, maxLines: 2),
            //按键名称
            FormHelper.textInput(name: ProductEditFields.mRemarks, labelText: LocaleKeys.keyName.tr, maxLines: 2),
            //食品备注
            FormHelper.textInput(
              name: ProductEditFields.mMeasurement,
              labelText: LocaleKeys.productRemarks.tr,
              suffixIcon: IconButton(
                onPressed: () async {
                  String? result = await Get.toNamed(Routes.OPEN_PRODUCT_REMARKS);
                  if (result?.isNotEmpty ?? false) {
                    controller.formKey.currentState?.fields[ProductEditFields.mMeasurement]?.didChange(result);
                  }
                },
                icon: Icon(Icons.file_open, color: AppColors.openColor),
              ),
            ),
            //单位
            FormHelper.selectInput(
              name: ProductEditFields.mUnit,
              labelText: LocaleKeys.unit.tr,
              items: [
                DropdownMenuItem(value: "", child: Text("")),
                if (controller.units.isNotEmpty)
                  ...controller.units.map(
                    (e) => DropdownMenuItem(
                      value: e.mUnit,
                      child: FittedBox(child: Text(e.mUnit.toString())),
                    ),
                  ),
              ],
            ),
            //售罄
            FormHelper.selectInput(
              name: ProductEditFields.mSoldOut,
              labelText: LocaleKeys.soldOut.tr,
              items: [
                DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
              ],
            ),
            //不具折上折
            //不具服务费
            //排序
          ],
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return Text("detail");
  }

  Widget _buildBarcode() {
    return Text("barcode");
  }

  Widget _buildShop() {
    return Text("shop");
  }

  Widget _buildSetMealLimit() {
    return Text("setMeal limit");
  }

  Widget _buildSetMeal() {
    return Text("setMeal");
  }
}
