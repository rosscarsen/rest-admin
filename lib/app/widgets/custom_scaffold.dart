import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../routes/app_pages.dart';
import '../translations/locale_keys.dart';
import '../utils/custom_alert.dart';
import '../utils/storage_manage.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.route,
    required this.body,
    this.actions,
    required this.title,
    this.mobileThreshold = 1024,
  });

  final Widget body;
  final String route;
  final List<Widget>? actions;
  final String title;
  final double mobileThreshold;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ObjectKey(Get.locale),
      child: AdminScaffold(
        //backgroundColor: Colors.white,
        leadingIcon: Icon(Icons.menu),
        mobileThreshold: mobileThreshold,
        appBar: AppBar(
          title: Text(title),
          //backgroundColor: Theme.of(context).primaryColor,
          //foregroundColor: Colors.white,
          actions: actions,
        ),

        sideBar: SideBar(
          backgroundColor: const Color(0xFFEEEEEE),
          borderColor: const Color(0xFFE7E7E7),
          iconColor: Color.fromARGB(234, 68, 68, 68),
          activeIconColor: Theme.of(context).primaryColor,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade700),
          activeTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
          items: [
            // 仪表盘
            AdminMenuItem(title: LocaleKeys.salesView.tr, route: Routes.DASHBOARD, icon: FontAwesomeIcons.gauge),
            // 主档
            AdminMenuItem(
              title: LocaleKeys.master.tr,
              icon: FontAwesomeIcons.ccMastercard,
              children: [
                // 产品
                AdminMenuItem(title: LocaleKeys.product.tr, route: Routes.PRODUCTS, icon: FontAwesomeIcons.productHunt),
                // 类目
                AdminMenuItem(title: LocaleKeys.category.tr, route: Routes.CATEGORY, icon: Icons.category),
                // 食品备注
                AdminMenuItem(
                  title: LocaleKeys.productRemarks.tr,
                  route: Routes.PRODUCT_REMARKS,
                  icon: FontAwesomeIcons.mars,
                ),
                //客户
                AdminMenuItem(title: LocaleKeys.customer.tr, route: Routes.CUSTOMER, icon: FontAwesomeIcons.user),
                //供应商
                AdminMenuItem(title: LocaleKeys.supplier.tr, route: Routes.SUPPLIER, icon: Icons.support),
                //店铺
                AdminMenuItem(title: LocaleKeys.stock.tr, route: Routes.STOCK, icon: FontAwesomeIcons.store),
                //货币
                AdminMenuItem(title: LocaleKeys.currency.tr, route: Routes.CURRENCY, icon: Icons.monetization_on),
                //单位
                AdminMenuItem(title: LocaleKeys.unit.tr, route: Routes.UNIT, icon: Icons.format_list_numbered),
                //套餐
                AdminMenuItem(title: LocaleKeys.setMeal.tr, route: Routes.SET_MENU, icon: FontAwesomeIcons.medal),
                //部门
                AdminMenuItem(title: LocaleKeys.department.tr, route: Routes.DEPARTMENT, icon: Icons.group),
                //支付方式
                AdminMenuItem(title: LocaleKeys.paymentMethod.tr, route: Routes.PAY_METHOD, icon: Icons.payment),
                //网上支付方式
                AdminMenuItem(
                  title: LocaleKeys.networkPayMethod.tr,
                  route: Routes.NETWORK_PAY_METHOD,
                  icon: FontAwesomeIcons.networkWired,
                ),
                //台面
                AdminMenuItem(title: LocaleKeys.mesa.tr, route: Routes.MESA, icon: FontAwesomeIcons.table),
                //日历
                AdminMenuItem(title: LocaleKeys.calendar.tr, route: Routes.CALENDAR, icon: FontAwesomeIcons.calendar),
                //時段銷售
                AdminMenuItem(title: LocaleKeys.timeSales.tr, route: Routes.TIME_SALES, icon: FontAwesomeIcons.clock),
                //台卡
                AdminMenuItem(title: LocaleKeys.decca.tr, route: Routes.DECCA, icon: FontAwesomeIcons.creditCard),
                //画面模式 类目
                AdminMenuItem(
                  title: LocaleKeys.screenModeCategory.tr,
                  route: Routes.SCREEN_MODE_CATEGORY,
                  icon: FontAwesomeIcons.layerGroup,
                ),
              ],
            ),
            // 供应商发票
            AdminMenuItem(
              title: LocaleKeys.supplierInvoice.tr,
              icon: FontAwesomeIcons.supple,
              route: Routes.SUPPLIER_INVOICE,
            ),
            // 语言
            AdminMenuItem(
              title: LocaleKeys.language.tr,
              icon: FontAwesomeIcons.language,
              children: [
                AdminMenuItem(
                  title: "中文简体",
                  route: "locale_zh_CN",
                  icon: Get.locale.toString() == "zh_CN" ? FontAwesomeIcons.check : null,
                ),

                AdminMenuItem(
                  title: "中文繁体",
                  route: "locale_zh_HK",
                  icon: Get.locale.toString() == "zh_HK" ? FontAwesomeIcons.check : null,
                ),
                AdminMenuItem(
                  title: "English",
                  route: "locale_en_US",
                  icon: Get.locale.toString() == "en_US" ? FontAwesomeIcons.check : null,
                ),
              ],
            ),
            // 退出登录
            AdminMenuItem(
              title: LocaleKeys.logout.tr,
              route: Routes.SIGNIN,
              icon: FontAwesomeIcons.arrowRightFromBracket,
            ),
          ],
          selectedRoute: route,
          onSelected: (item) {
            debugPrint('sideBar: onTap(): title = ${item.title}, route = ${item.route}, route = $route');

            if (item.route != null && item.route != route) {
              if (item.route.toString().contains("locale")) {
                final locale = switch (item.route) {
                  "locale_zh_CN" => const Locale("zh", "CN"),
                  "locale_zh_HK" => const Locale("zh", "HK"),
                  _ => const Locale("en", "US"),
                };
                final StorageManage storageManage = StorageManage();
                storageManage.write(Config.localStorageLanguage, locale.toString());
                Get.updateLocale(locale);
              } else if (item.route == Routes.SIGNIN) {
                CustomAlert.iosAlert(
                  message: LocaleKeys.confirmLoginOut.tr,
                  showCancel: true,
                  onConfirm: () async {
                    final storageManage = StorageManage();
                    await storageManage.remove(Config.localStorageHasLogin);
                    Get.offAllNamed(item.route!);
                  },
                );
              } else {
                Get.offAndToNamed(item.route!);
              }
            }
          },
          /*  header: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text('header', style: TextStyle(color: Colors.white)),
            ),
          ), */
          footer: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: FittedBox(
                  child: Text(
                    '© 2023-${DateTime.now().year} [Pericles]. All rights reserved',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: body,
      ),
    );
  }
}
