import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../config.dart';
import '../routes/app_pages.dart';
import '../translations/locale_keys.dart';
import '../utils/aes_gcm_crypto.dart';
import '../utils/custom_alert.dart';
import '../utils/custom_dialog.dart';
import '../utils/local_cache.dart';
import '../utils/logger.dart';
import '../utils/storage_manage.dart';
import 'dio_api_result.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static late Dio _dio;

  // 错误代码常量
  static const int _loginInvalidCode = 401;
  static const int _noPermission = 10002;

  // 错误消息
  static final String _serviceError = LocaleKeys.serviceError.tr;
  static final String _dataException = LocaleKeys.dataException.tr;
  static final String _unknownError = LocaleKeys.unknownError.tr;
  static final String _connectionTimeout = LocaleKeys.connectionTimeout.tr;
  static final String _receiveTimeout = LocaleKeys.receiveTimeout.tr;

  static ApiClient get internal => _instance;

  factory ApiClient() {
    final baseOptions = BaseOptions(
      baseUrl: Config.baseurl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 60),
      validateStatus: (status) => status != null,
    );

    _dio = Dio(baseOptions);

    // 添加日志拦截器
    /*  _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ); */
    if (!kIsWeb) {
      // 忽略 HTTPS 证书验证
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.findProxy = (uri) {
          return "DIRECT";
        };
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          return true;
        };
        return client;
      };
    }
    // 添加认证拦截器
    _dio.interceptors.add(AuthInterceptor());
    // 添加错误处理拦截器
    _dio.interceptors.add(ErrorHandlerInterceptor());
    // 添加日志拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d(
            '原始请求信息: ${["method:${options.method}", "uri:${options.uri}", "queryParameters:${options.queryParameters}", "data:${options.data}", "headers:${options.headers}", "contentType:${options.contentType}", "responseType:${options.responseType}"]}',
          );
          return handler.next(options);
        },
      ),
    );
    return _instance;
  }

  ApiClient._internal();

  // POST请求
  Future<DioApiResult> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 下载excel
  Future<DioApiResult> generateExcel(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final finalQuery = {"lang": (Get.locale?.toString() ?? "zh_HK").toLowerCase(), ...?queryParameters};
      if (data is Map<String, dynamic>) {
        finalQuery.addAll(data);
      }
      final response = await _dio.get(
        path,
        queryParameters: finalQuery,
        options: Options(responseType: ResponseType.bytes),
      );
      // 检查状态码
      if (response.statusCode != 200) {
        return DioApiResult(success: false, error: 'HTTP ${response.statusCode}');
      }
      // 检查响应内容类型
      final Headers headers = response.headers;
      final contentType = headers.value('content-type')?.toLowerCase();
      if (contentType?.contains('application/json') ?? false) {
        // 处理JSON权限错误
        final jsonData = json.decode(utf8.decode(response.data)) as Map<String, dynamic>;
        if (jsonData["status"].toString() == _noPermission.toString()) {
          return DioApiResult(success: false, hasPermission: false, error: LocaleKeys.noPermission.tr);
        }
        return DioApiResult(success: false, error: LocaleKeys.generateFileFailed.tr);
      } else {
        // 处理Excel二进制数据
        String fileName = 'download.xlsx';
        final contentDisposition = headers.value('content-disposition');

        if (contentDisposition != null) {
          final match = RegExp(r'filename\s*=\s*"?([^"]+)"?;?').firstMatch(contentDisposition);
          if (match != null) fileName = match.group(1) ?? '';
        }

        return DioApiResult<Uint8List>(success: true, data: response.data, fileName: fileName);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // GET请求
  Future<DioApiResult> get(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final finalQuery = {...?queryParameters};
      if (data is Map<String, dynamic>) {
        finalQuery.addAll(data);
      }
      final response = await _dio.get(path, queryParameters: finalQuery);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 上传图片
  Future<DioApiResult> uploadImage({
    required XFile image,
    required String uploadUrl,
    Map<String, dynamic>? extraData,
    String? code,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final imageData = await image.readAsBytes();
      final extension = path.extension(image.path);
      final finalFileName = code != null ? "$code$extension" : path.basename(image.path);
      logger.i("Uploading image to $uploadUrl with filename $finalFileName");
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);
      final imageFile = MultipartFile.fromBytes(imageData, filename: finalFileName, contentType: mediaType);
      final formData = FormData.fromMap({"file": imageFile, if (extraData != null) ...extraData});
      final response = await _dio.post(uploadUrl, data: formData, onSendProgress: onSendProgress);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 上传文件
  Future<DioApiResult> uploadFile({
    required File file,
    required String uploadUrl,
    Map<String, dynamic>? extraData,
    String? code,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final extension = path.extension(file.path);
      final finalFileName = code != null ? "$code$extension" : path.basename(file.path);
      logger.i("Uploading file to $uploadUrl with filename $finalFileName");
      final mimeType = lookupMimeType(file.path);
      // 由于 mimeType 是 String? 类型，而 MediaType.parse 要求 String 类型，因此需要处理 null 值
      final mediaType = mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream');
      logger.f(mediaType);
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: finalFileName, contentType: mediaType),
        if (extraData != null) ...extraData,
      });
      final response = await _dio.post(uploadUrl, data: formData, onSendProgress: onSendProgress);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 处理响应
  DioApiResult _handleResponse(Response response) {
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      return DioApiResult(success: false, error: 'HTTP $statusCode ${response.statusMessage}');
    }

    final responseData = response.data;

    final String dataJson = responseData?.toString() ?? '';

    if (dataJson.isEmpty || dataJson == 'null' || dataJson == '[]') {
      return DioApiResult(success: false, error: _dataException);
    }

    try {
      final decoded = jsonDecode(dataJson);
      if (decoded is Map<String, dynamic>) {
        final Map<String, dynamic> dataMap = Map.from(decoded);

        if (dataMap.containsKey('apiResult') &&
            dataMap['apiResult'] is List &&
            (dataMap['apiResult'] as List).isEmpty) {
          dataMap['apiResult'] = null;
        }
        return DioApiResult(success: true, data: jsonEncode(dataMap));
      }
      return DioApiResult(success: true, data: dataJson);
    } catch (err) {
      return DioApiResult(success: false, error: _dataException);
    }
  }

  // 处理错误
  DioApiResult _handleError(Object e) {
    if (e is DioException && e.response?.statusCode == _loginInvalidCode) {
      CustomAlert.iosAlert(
        message: LocaleKeys.loginInvalid.tr,
        onConfirm: () {
          final StorageManage storageManage = StorageManage();
          storageManage.remove(Config.localStorageHasLogin);
          Get.offAllNamed(Routes.SIGNIN);
        },
      );
      return DioApiResult(success: false, error: LocaleKeys.loginInvalid.tr);
    } else {
      return DioApiResult(
        success: false,
        error: e is DioException ? e.error?.toString() ?? _unknownError : _serviceError,
      );
    }
  }
}

// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (Get.currentRoute == Routes.SIGNIN) {
      return handler.next(options);
    }

    final loginInfo = LocalCache.cacheInfo();
    if (loginInfo == null) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: ApiClient._loginInvalidCode),
          error: LocaleKeys.loginInvalid.tr,
        ),
      );
    }
    final loginMap = loginInfo.toJson();
    loginMap.removeWhere((key, value) => key == "aesKey");
    final String plaintext = jsonEncode(loginMap);
    final encryptedData = await AesGcmCrypto.encrypt(plaintext, loginInfo.aesKey ?? "");
    final String encryptedString = base64Encode(utf8.encode(jsonEncode(encryptedData)));

    options.headers.addAll({
      "Authorization": "Bearer $encryptedString",
      "X-Company-Key": "resetAdmin_${loginInfo.company}_${loginInfo.user}",
    });
    return handler.next(options);
  }
}

// 错误处理拦截器
class ErrorHandlerInterceptor extends Interceptor {
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: Response(
            requestOptions: response.requestOptions,
            statusCode: ApiClient._loginInvalidCode,
            data: response.data,
          ),
          error: LocaleKeys.loginInvalid.tr,
        ),
      );
    }

    ///  文件流 / bytes，直接跳过
    if (response.requestOptions.responseType == ResponseType.bytes || response.data is Uint8List) {
      return handler.next(response);
    }

    ///  非 JSON 跳过
    final contentType = response.headers.value('content-type')?.toLowerCase();
    if (contentType != null && !contentType.contains('application/json')) {
      return handler.next(response);
    }
    return handler.next(response);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // 登录失效
    if (err.response?.statusCode == ApiClient._loginInvalidCode) {
      CustomAlert.iosAlert(
        message: LocaleKeys.loginInvalid.tr,
        onConfirm: () {
          final StorageManage storageManage = StorageManage();
          storageManage.remove(Config.localStorageHasLogin);
          Get.offAllNamed(Routes.SIGNIN);
        },
      );

      return handler.reject(err);
    }
    // 超时处理
    if (err.type == DioExceptionType.connectionTimeout) {
      CustomDialog.errorMessages(ApiClient._connectionTimeout);
      return handler.resolve(err.response!);
    }
    if (err.type == DioExceptionType.receiveTimeout) {
      CustomDialog.errorMessages(ApiClient._receiveTimeout);
      return handler.resolve(err.response!);
    }

    return handler.next(err);
  }
}
