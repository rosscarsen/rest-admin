import 'package:get/get.dart';

import 'en_us.dart';
import 'zh_cn.dart';
import 'zh_tw.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'zh_TW': zhTW, 'zh_CN': zhCN, 'en_US': enUS};
}
