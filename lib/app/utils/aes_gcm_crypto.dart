import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:webcrypto/webcrypto.dart';

/// AES-GCM 加密工具类
/// 提供了密钥生成、加密等功能
class AesGcmCrypto {
  /// 生成一个随机数(nonce)
  /// @param length 随机数的长度，默认为12字节
  /// @return 返回一个Uint8List类型的随机数
  static Uint8List generateNonce({int length = 12}) {
    // 使用安全的随机数生成器
    final random = Random.secure();
    // 生成指定长度的随机数列表，每个元素在0-255之间
    return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
  }

  /// 生成一个Base64编码的AES密钥
  /// @return 返回一个Future<String>，表示异步生成的Base64编码密钥
  static Future<String> generateBase64Key() async {
    // 生成一个256位的AES密钥
    final key = await AesGcmSecretKey.generateKey(256);
    // 导出密钥的原始字节
    final raw = await key.exportRawKey();
    // 将原始字节编码为Base64字符串
    return base64Encode(raw);
  }

  /// 使用AES-GCM算法加密明文
  /// @param plaintext 要加密的明文
  /// @return 返回一个Future<Map<String, String>>，包含加密后的nonce、密文和认证标签
  static Future<Map<String, String>> encrypt(String plaintext, String base64Key) async {
    // 将Base64编码的密钥解码为原始字节
    final rawKey = base64Decode(base64Key);
    // 导入原始密钥
    final key = await AesGcmSecretKey.importRawKey(rawKey);
    // 生成随机数(nonce)
    final nonce = generateNonce();
    // 加密明文
    final encrypted = await key.encryptBytes(utf8.encode(plaintext), nonce);
    // 从加密结果中提取认证标签(最后16字节)
    final tag = encrypted.sublist(encrypted.length - 16);
    // 从加密结果中提取密文(除最后16字节外的所有字节)
    final cipher = encrypted.sublist(0, encrypted.length - 16);
    // 返回Base64编码的nonce、密文和认证标签
    return {"nonce": base64Encode(nonce), "cipher": base64Encode(cipher), "tag": base64Encode(tag)};
  }
}
