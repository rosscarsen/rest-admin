import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

import 'app/config.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/app_translations.dart';
import 'app/utils/storage_manage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await findSystemLocale(); //date_field使用
  await StorageManage.init();
  final StorageManage storageManage = StorageManage();
  //初始语言
  String localeString = await storageManage.read(Config.localStorageLanguage) ?? "zh_HK";
  List<String> localeParts = localeString.split('_');
  final Locale initialLocale = Locale(localeParts[0], localeParts.length > 1 ? localeParts[1] : '');

  final hasLogin =
      (storageManage.read(Config.localStorageHasLogin) ?? false) &&
      (storageManage.read(Config.localStorageLoginInfo) != null);

  final String initialRoute = hasLogin ? Routes.DASHBOARD : Routes.SIGNIN;
  storageManage.write(Config.localStorageLanguage, localeString);

  if (!kIsWeb && Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
  }

  runApp(MyApp(initialLocale, initialRoute));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  final String initialRoute;
  const MyApp(this.initialLocale, this.initialRoute, {super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rest Admin",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: initialLocale,

      //defaultTransition: Transition.noTransition,
      supportedLocales: const [Locale('zh', 'CN'), Locale('zh', 'HK'), Locale('en', 'US')],

      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      localeResolutionCallback: (locale, supportedLocales) =>
          supportedLocales.contains(locale) ? locale : initialLocale,

      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
      builder: (context, child) {
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0), alwaysUse24HourFormat: true),
          child: child!,
        );
        child = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(isDense: context.isPhoneOrWider),
            ),
            child: child,
          ),
        );

        //加载框
        child = EasyLoading.init()(context, child);
        return child;
      },
    );
  }
}
