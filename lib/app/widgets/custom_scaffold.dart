import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../routes/app_pages.dart';
import '../translations/locale_keys.dart';
import '../utils/custom_alert.dart';
import '../utils/storage_manage.dart';

class CustomScaffold extends StatefulWidget {
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
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final ScrollController scrollController = ScrollController();
  late List<AdminMenuItem> menuItems;
  // 用于防抖的定时器
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _initializeMenuItems();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant CustomScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当语言变化时，重新初始化菜单项
    if (Get.locale != null && Get.locale.toString() != oldWidget.route) {
      _initializeMenuItems();
    }
    // 当路由变化时，滚动到选中项
    if (widget.route != oldWidget.route) {
      scrollToSelected();
    }
  }

  // 初始化菜单项
  void _initializeMenuItems() {
    menuItems = [
      _createMenuItem(LocaleKeys.salesView.tr, Routes.DASHBOARD, FontAwesomeIcons.gauge),
      AdminMenuItem(
        title: LocaleKeys.master.tr,
        icon: FontAwesomeIcons.ccMastercard,
        children: [
          _createMenuItem(LocaleKeys.product.tr, Routes.PRODUCTS, FontAwesomeIcons.productHunt),
          _createMenuItem(LocaleKeys.category.tr, Routes.CATEGORY, Icons.category),
          _createMenuItem(LocaleKeys.productRemarks.tr, Routes.PRODUCT_REMARKS, FontAwesomeIcons.mars),
          _createMenuItem(LocaleKeys.customer.tr, Routes.CUSTOMER, FontAwesomeIcons.user),
          _createMenuItem(LocaleKeys.supplier.tr, Routes.SUPPLIER, Icons.support),
          _createMenuItem(LocaleKeys.stock.tr, Routes.STOCK, FontAwesomeIcons.store),
          _createMenuItem(LocaleKeys.currency.tr, Routes.CURRENCY, Icons.monetization_on),
          _createMenuItem(LocaleKeys.unit.tr, Routes.UNIT, Icons.format_list_numbered),
          _createMenuItem(LocaleKeys.setMeal.tr, Routes.SET_MENU, FontAwesomeIcons.medal),
          _createMenuItem(LocaleKeys.department.tr, Routes.DEPARTMENT, Icons.group),
          _createMenuItem(LocaleKeys.paymentMethod.tr, Routes.PAY_METHOD, Icons.payment),
          _createMenuItem(LocaleKeys.networkPayMethod.tr, Routes.NETWORK_PAY_METHOD, FontAwesomeIcons.networkWired),
          _createMenuItem(LocaleKeys.tables.tr, Routes.TABLES, FontAwesomeIcons.table),
          _createMenuItem(LocaleKeys.calendar.tr, Routes.CALENDAR, FontAwesomeIcons.calendar),
          _createMenuItem(LocaleKeys.timeSales.tr, Routes.TIME_SALES, FontAwesomeIcons.clock),
          _createMenuItem(LocaleKeys.tableCard.tr, Routes.TABLE_CARD, FontAwesomeIcons.creditCard),
          _createMenuItem(LocaleKeys.screenModeCategory.tr, Routes.SCREEN_MODE_CATEGORY, FontAwesomeIcons.layerGroup),
        ],
      ),

      _createMenuItem(LocaleKeys.supplierInvoice.tr, Routes.SUPPLIER_INVOICE, FontAwesomeIcons.supple),

      AdminMenuItem(
        title: LocaleKeys.language.tr,
        icon: FontAwesomeIcons.language,
        children: _createLanguageMenuItems(),
      ),

      _createMenuItem(LocaleKeys.logout.tr, Routes.SIGNIN, FontAwesomeIcons.arrowRightFromBracket),
    ];
  }

  // 创建单个菜单项的辅助方法
  AdminMenuItem _createMenuItem(String title, String route, dynamic icon) {
    return AdminMenuItem(title: title, route: route, icon: icon);
  }

  // 创建语言菜单项
  List<AdminMenuItem> _createLanguageMenuItems() {
    return [
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
    ];
  }

  /// 查找当前 route 在侧栏中的索引和路径
  (int, bool) _findMenuIndexAndIsVisible(List<AdminMenuItem> items, String target) {
    int index = 0;
    bool found = false;

    bool search(List<AdminMenuItem> list) {
      for (final item in list) {
        if (item.route == target) {
          found = true;
          return true;
        }
        index++;
        if (item.children.isNotEmpty && search(item.children)) return true;
      }
      return false;
    }

    search(items);
    return (index, found);
  }

  /// 自动滚动到选中项（带防抖）
  void scrollToSelected() {
    if (_isScrolling) return;

    _isScrolling = true;

    // 防抖，避免频繁滚动
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      const itemHeight = 49.0; // 菜单项高度，可根据实际情况调整
      final (idx, found) = _findMenuIndexAndIsVisible(menuItems, widget.route);

      // 如果找到了路由
      if (found && scrollController.hasClients) {
        final targetOffset = idx * itemHeight;
        final currentOffset = scrollController.offset;
        final viewHeight = scrollController.position.viewportDimension;

        // 检查是否已经在可视区域内
        if (targetOffset >= currentOffset && targetOffset <= currentOffset + viewHeight - itemHeight) {
          _isScrolling = false;
          return;
        }

        // 计算更合适的滚动位置，使选中项居中
        final newOffset = targetOffset - (viewHeight / 2 - itemHeight / 2);
        final clampedOffset = newOffset.clamp(0.0, scrollController.position.maxScrollExtent);

        scrollController
            .animateTo(clampedOffset, duration: const Duration(milliseconds: 300), curve: Curves.linear)
            .then((_) {
              _isScrolling = false;
            })
            .catchError((_) {
              _isScrolling = false;
            });
      } else {
        _isScrolling = false;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _handleMenuTap(AdminMenuItem item) async {
    if (item.route == widget.route) return;

    if (item.route != null && item.route!.contains("locale")) {
      final locale = switch (item.route) {
        "locale_zh_CN" => const Locale("zh", "CN"),
        "locale_zh_HK" => const Locale("zh", "HK"),
        _ => const Locale("en", "US"),
      };

      try {
        await StorageManage().write(Config.localStorageLanguage, locale.toString());
        Get.updateLocale(locale);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _initializeMenuItems(); // 更新菜单项中的语言选中状态
            scrollToSelected();
          }
        });
      } catch (e) {
        debugPrint('Failed to change language: $e');
        // 可以在这里添加错误处理，例如显示错误提示
      }
      return;
    }

    if (item.route == Routes.SIGNIN) {
      return CustomAlert.iosAlert(
        message: LocaleKeys.confirmLoginOut.tr,
        showCancel: true,
        onConfirm: () async {
          try {
            await StorageManage().remove(Config.localStorageHasLogin);
            Get.offAllNamed(item.route!);
          } catch (e) {
            debugPrint('Failed to logout: $e');
            // 可以在这里添加错误处理
          }
        },
      );
    }

    if (item.route != null) {
      try {
        Get.offAndToNamed(item.route!);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) scrollToSelected();
        });
      } catch (e) {
        debugPrint('Failed to navigate: $e');
        // 可以在这里添加错误处理
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
      child: KeyedSubtree(
        key: ObjectKey(Get.locale),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (_, _) {
            CustomAlert.iosAlert(
              message: LocaleKeys.confirmExitSystem.tr,
              showCancel: true,
              onConfirm: SystemNavigator.pop,
            );
          },
          child: AdminScaffold(
            leadingIcon: const Icon(Icons.menu),
            mobileThreshold: widget.mobileThreshold,
            appBar: AppBar(title: Text(widget.title), actions: widget.actions),
            sideBar: SideBar(
              scrollController: scrollController,
              backgroundColor: const Color(0xFFF3F4F6),
              borderColor: const Color(0xFFE7E7E7),
              iconColor: const Color.fromARGB(234, 68, 68, 68),
              activeIconColor: Theme.of(context).primaryColor,
              textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              activeTextStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              items: menuItems,
              selectedRoute: widget.route,
              onSelected: _handleMenuTap,
            ),
            body: widget.body,
          ),
        ),
      ),
    );
  }
}
