import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class PdfThemeManager {
  PdfThemeManager._internal(); // 私有构造

  static final PdfThemeManager instance = PdfThemeManager._internal();

  pw.ThemeData? _theme; // 缓存ThemeData

  /// 获取 ThemeData（懒加载）
  Future<pw.ThemeData> getTheme() async {
    _theme ??= await _buildTheme();
    return _theme!;
  }

  /// 内部实际构建字体和ThemeData的方法
  Future<pw.ThemeData> _buildTheme() async {
    //final baseFont = await PdfGoogleFonts.notoSansSCRegular();
    final baseFont = pw.Font.ttf(await rootBundle.load('assets/fonts/notoSansSCRegular.ttf'));
    final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/notoSansSCBold.ttf'));
    final italicFont = pw.Font.ttf(await rootBundle.load('assets/fonts/notoSansItalic.ttf'));
    final fallbackFont = pw.Font.ttf(await rootBundle.load('assets/fonts/notoSansSymbols2Regular.ttf'));

    return pw.ThemeData.withFont(base: baseFont, bold: boldFont, italic: italicFont, icons: baseFont).copyWith(
      defaultTextStyle: pw.TextStyle(font: baseFont, fontFallback: [fallbackFont], fontSize: 10),
    );
  }
}
