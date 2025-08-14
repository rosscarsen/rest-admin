import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../translations/locale_keys.dart';
import 'logger.dart';

class Functions {
  static double mmToPoints(double mm) => mm * 2.83464567; //毫米转点

  //检测图片是否存在
  static Future<bool> checkImageExists(String imageUrl) async {
    try {
      final dio = Dio();
      final response = await dio.head(imageUrl);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// 选择图片
  static Future<XFile?> imagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    if (kIsWeb) {
      return await picker.pickImage(source: ImageSource.gallery);
    } else if (Platform.isAndroid || Platform.isIOS) {
      // 用 Completer 等待结果
      final Completer<XFile?> completer = Completer<XFile?>();
      Get.bottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Config.defaultGap,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(LocaleKeys.camera.tr),
              onTap: () async {
                Get.closeAllBottomSheets();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                completer.complete(image); // 设置返回值
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text(LocaleKeys.album.tr),
              onTap: () async {
                Get.closeAllBottomSheets();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                completer.complete(image); // 设置返回值
              },
            ),
          ],
        ).paddingSymmetric(vertical: Config.defaultPadding),
        backgroundColor: Colors.white,
      );

      return completer.future; // 等待用户选择完成
    } else {
      return await picker.pickImage(source: ImageSource.gallery);
    }
  }

  /// 压缩图片
  static Future<dynamic> compressImage(
    dynamic input, {
    int maxWidth = 600,
    int maxHeight = 600,
    int quality = 85,
  }) async {
    try {
      img.Image? image;

      if (kIsWeb) {
        // Web 端: input 是 Uint8List
        Uint8List imageBytes = input as Uint8List;
        image = img.decodeImage(imageBytes);
      } else {
        // 非 Web 端: input 是 File
        File file = input as File;
        List<int> imageBytes = await file.readAsBytes();
        image = img.decodeImage(Uint8List.fromList(imageBytes));
      }
      if (image == null) return null;
      // 计算缩放比例
      int targetWidth, targetHeight;
      double aspectRatio = image.width / image.height;
      if (aspectRatio > 1) {
        targetWidth = maxWidth;
        targetHeight = (maxWidth / aspectRatio).round();
      } else {
        targetHeight = maxHeight;
        targetWidth = (maxHeight * aspectRatio).round();
      }

      // **缩放图片**
      img.Image resizedImage = img.copyResize(image, width: targetWidth, height: targetHeight);

      // **转换为 JPG 并压缩**
      List<int> jpgBytes = img.encodeJpg(resizedImage, quality: quality);

      if (kIsWeb) {
        return Uint8List.fromList(jpgBytes); // Web 端返回 Uint8List
      } else {
        // 移动端 & 桌面端 保存到文件
        final String targetPath = input.path.replaceAll(RegExp(r"\.\w+$"), "_compressed.jpg");
        File compressedFile = File(targetPath);
        await compressedFile.writeAsBytes(jpgBytes);
        return compressedFile; // 返回压缩后的 File
      }
    } catch (e) {
      logger.e("图片压缩失败: $e");
      return null;
    }
  }

  /// 比较map是否一样
  /// sourceMap 源数据
  /// targetMap 目标数据
  static bool compareMap(Map<String, dynamic> sourceMap, Map<String, dynamic> targetMap) {
    // 1. 只保留目标字段
    final sourceRowFiltered = Map.fromEntries(sourceMap.entries.where((e) => targetMap.containsKey(e.key)));

    // 2. 类型统一（全部转字符串）
    final normalizedSource = sourceRowFiltered.map((k, v) => MapEntry(k, (v ?? "").toString()));
    final normalizedTarget = targetMap.map((k, v) => MapEntry(k, (v ?? '').toString()));

    // 3. 比较
    const eq = DeepCollectionEquality();
    return eq.equals(normalizedSource, normalizedTarget);
  }
}
