import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../config.dart';
import '../routes/app_pages.dart';
import '../translations/locale_keys.dart';
import '../utils/custom_alert.dart';
import '../utils/easy_loading.dart';
import '../utils/local_cache.dart';

class ApiClient {
  static Logger logger = Logger();

  static final ApiClient _instance = ApiClient._internal();
  static late Dio _dio;
  static const int _loginInvalidCode = 10001; //登录过期
  static const int _noPermission = 10002; //没有权限
  static const String _contentType = "application/x-www-form-urlencoded";
  static final String _serviceError = LocaleKeys.serviceError.tr;
  static final String _dataException = LocaleKeys.dataException.tr;
  static final String _unknownError = LocaleKeys.unknownError.tr;

  static ApiClient get internal => _instance;

  factory ApiClient() {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: Config.baseurl,
      contentType: _contentType,
      responseType: ResponseType.plain,
      connectTimeout: Duration(minutes: 2),
      receiveTimeout: Duration(minutes: 2),
      validateStatus: (status) => status != null,
    );

    _dio = Dio(baseOptions);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (Get.currentRoute == Routes.SIGNIN) {
            return handler.next(options);
          } else {
            final dsn = LocalCache.cacheInfo();
            if (dsn.isEmpty) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(requestOptions: options, statusCode: _loginInvalidCode),
                  error: LocaleKeys.loginInvalid.tr,
                  message: LocaleKeys.loginInvalid.tr,
                ),
              );
            }
            options.headers.addAll(dsn);
            return handler.next(options);
          }
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == _loginInvalidCode) {
            return handler.resolve(e.response!);
          }
          return handler.next(e);
        },
      ),
    );

    return _instance;
  }

  ApiClient._internal();

  // 定义一个异步方法post，用于发送POST请求
  // 参数path表示请求的路径
  // 可选参数data表示请求体数据
  // 可选参数queryParameters表示查询参数
  Future<String?> post(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      //logger.d(response);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  // 定义一个异步方法get，用于发送Get请求
  // 参数path表示请求的路径
  // 可选参数data表示请求体数据
  // 可选参数queryParameters表示查询参数
  Future<String?> get(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  // 定义一个异步函数，用于上传图片，返回一个Future<String?>
  // 必须传入的图片文件
  // 必须传入的上传URL
  // 可选的额外数据
  // 可选的文件名前缀
  Future<String?> uploadImage({
    required XFile image,
    required String uploadUrl,
    Map<String, dynamic>? extraData,
    String? code,
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
      final response = await _dio.post(uploadUrl, data: formData);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
    return null;
  }

  // 定义一个私有方法 _handleResponse，用于处理 HTTP 响应
  String? _handleResponse(Response response) {
    if (response.statusCode != 200) {
      dismissLoading();
      errorMessages(_serviceError);
      return null;
    }

    final dataJson = response.data.toString();
    final Map<String, dynamic> dataMap = jsonDecode(dataJson) ?? {};

    if (dataMap.isNotEmpty && dataMap["status"].toString() == _noPermission.toString()) {
      dismissLoading();
      showToast(LocaleKeys.noPermission.tr);
      return Config.noPermission;
    }

    if (dataJson.isEmpty || dataJson == "null" || dataJson == "[]") {
      dismissLoading();
      errorMessages(_dataException);
      return null;
    }
    return dataJson;
  }

  // 定义一个私有方法 _handleError，用于处理错误
  void _handleError(Object e) {
    if (e is DioException && e.response?.statusCode == _loginInvalidCode) {
      CustomAlert.iosAlert(
        LocaleKeys.loginInvalid.tr,
        onConfirm: () {
          Get.offAllNamed(Routes.SIGNIN);
        },
      );
    } else {
      dismissLoading();
      errorMessages(e is DioException ? e.error?.toString() ?? _unknownError : _serviceError);
    }
  }
}
