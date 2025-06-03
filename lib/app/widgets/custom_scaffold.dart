import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../routes/app_pages.dart';
import '../translations/locale_keys.dart';
import '../utils/stroage_manage.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.route, required this.body, this.actions, required this.title});

  final Widget body;
  final String route;
  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      key: ObjectKey(Get.locale),
      backgroundColor: Colors.white,
      leadingIcon: Icon(Icons.menu),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: actions,
      ),
      sideBar: SideBar(
        backgroundColor: const Color(0xFFEEEEEE),
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Color.fromARGB(234, 68, 68, 68),
        activeIconColor: Theme.of(context).primaryColor,
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Color.fromARGB(234, 68, 68, 68)),
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
            ],
          ),
          // 供应商发票
          AdminMenuItem(
            title: LocaleKeys.supplierInvoice.tr,
            icon: FontAwesomeIcons.supple,
            route: Routes.SUPPLIER_INVOICE,
          ),
          //语言
          AdminMenuItem(
            title: LocaleKeys.language.tr,
            icon: FontAwesomeIcons.language,
            children: [
              AdminMenuItem(
                title: LocaleKeys.simplifiedChinese.tr,
                route: "locale_zh_CN",
                icon: Get.locale.toString() == "zh_CN" ? FontAwesomeIcons.check : null,
              ),

              AdminMenuItem(
                title: LocaleKeys.traditionalChinese.tr,
                route: "locale_zh_HK",
                icon: Get.locale.toString() == "zh_HK" ? FontAwesomeIcons.check : null,
              ),
              AdminMenuItem(
                title: LocaleKeys.english.tr,
                route: "locale_en_US",
                icon: Get.locale.toString() == "en_US" ? FontAwesomeIcons.check : null,
              ),
            ],
          ),
        ],
        selectedRoute: route,
        onSelected: (item) {
          // debugPrint('sideBar: onTap(): title = ${item.title}, route = ${item.route}');

          if (item.route != null && item.route != route) {
            if (item.route.toString().contains("locale")) {
              final locale = switch (item.route) {
                "locale_zh_CN" => const Locale("zh", "CN"),
                "locale_zh_HK" => const Locale("zh", "HK"),
                _ => const Locale("en", "US"),
              };
              final StorageManage storageManage = StorageManage();
              storageManage.write(Config.localStroagelanguage, locale.toString());
              Get.updateLocale(locale);
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
          child: const Center(
            child: Text('footer', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      body: body,
    );
  }
}
