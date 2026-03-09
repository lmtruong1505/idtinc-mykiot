import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/env/env_config.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../shared/constants/pref_key.dart';
import '../../shared/constants/storage/shared_preference.dart';
import '../apis/end_point.dart';
import 'dio_logger.dart';

@injectable
class BaseDio {
  // khởi tạo biến
  Dio? _instance;

  //method for getting dio instance
  Dio _dio() {
    _instance = _createDioInstance();
    return _instance!;
  }

  var headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json',
  };

  Dio _createDioInstance() {
    late Dio dio;
    final token = AppSharedPreference.instance.getValue(PrefKeys.token);
    var header = headers;
    if (token != null) header = {...headers, 'authorization': 'Bearer $token'};
    dio = Dio(BaseOptions(headers: header));
    dio.interceptors.clear();
    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // options.headers['Access-Control-Allow-Origin'] = '*';
            // print(options.headers);
            options.headers['workspace-id'] = getCompanyId;
            options.headers.removeWhere(
              (key, value) =>
                  key.toUpperCase() == 'content-length'.toUpperCase() || key == 'content-length',
            );
            return handler.next(options);
          },
          onResponse: (response, handler) {
            if (response.data != null && response.data['code'] == 403) {
              response.data['message'] =
                  'Bạn không có quyền truy cập chức năng này.${kDebugMode ? ' (${response.data['message']})' : ''}';
            }
            return handler.next(response);
          },
          onError: (error, handler) async {
            // const int count = 1;
            String msg = 'Có lỗi hệ thống, vui lòng thử lại';
            if (error.response?.data is Map) {
              msg = error.response?.data['message'] ??
                  'Có lỗi hệ thống, vui lòng thử lại';
            }

            error = error.copyWith(
              //error: msg,
              message: msg,
            );
            // print(error.response);
            if ((error.response?.statusCode == 401 ||
                    error.response?.statusCode == 403) &&
                error.response?.data['detail'] != 'User not found') {
              final accessToken = await _getNewToken();
              if (accessToken.isEmpty) {
                return handler.next(error);
              } else {
                _saveTokenToStorage(accessToken);

                // Thử lại yêu cầu gốc
                final RequestOptions requestOptions = error.requestOptions;
                final opts = Options(method: requestOptions.method);
                dio.options.headers['Authorization'] = 'Bearer $accessToken';
                dio.options.headers['Accept'] = '*/*';
                final response = await dio.request(
                  requestOptions.path,
                  options: opts,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                );
                return handler.resolve(response);
              }
            } else {
              return handler.next(error);
            }
          },
        ),
        PrettyDioLogger(requestBody: true),
        CurlLoggerDioInterceptor(printOnSuccess: true),
      ],
    );
    return dio;
  }

  Future<String> _getNewToken() async {
    try {
      final payload = {
        'refresh':
            '${AppSharedPreference.instance.getValue(PrefKeys.tokenRefresh)}',
      };
      final res = await Dio(BaseOptions(headers: headers))
          .post('$baseURL/${Api.refreshToken}', data: payload);

      print(res.data['details']['access_token']);

      return res.data['details']['access_token'] ?? '';
    } catch (e) {
      return '';
    }
  }

  void _saveTokenToStorage(String token) {
    AppSharedPreference.instance.setValue(PrefKeys.token, token);
  }

// var dio = Dio(
//   BaseOptions(
//     headers: {
//       "authorization":
//           "Bearer ${AppSharedPreference.instance.getValue(PrefKeys.TOKEN)}",
//       "content-Type": "application/json",
//       "accept": "application/json",
//     },
//   ),
// );

  static String baseURL = EnvironmentConfig.BASE_URL_HTTP;

  Future<List<String>> checkVersion() async {
    final List<String> notes = [];
    try {
      final be = await _dio().get('$baseURL/${Api.checkversion}');

      if (be.data['details']?['notes'] is List) {
        for (final note in be.data['details']['notes']) {
          notes.add(note);
        }
        notes.removeWhere(
          (element) => element.isEmptyOrNull,
        );
      }
    } catch (e) {}
    return notes;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? data}) async {
    return _dio().get('$baseURL/$path', queryParameters: data);
  }

  Future<dynamic> post(String path, {Object? data}) async {
    return _dio().post('$baseURL/$path', data: data);
  }

  Future<dynamic> put(String path, {Object? data}) async {
    return _dio().put('$baseURL/$path', data: data);
  }

  Future<dynamic> delete(String path, {Object? data}) async {
    return _dio().delete('$baseURL/$path', data: data);
  }

  Future<dynamic> patch(String path, {Object? data}) async {
    return _dio().patch('$baseURL/$path', data: data);
  }

  Future<dynamic> getWithUrl(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    return _dio().get(
      path,
      queryParameters: data,
      options: options,
    );
  }

  Future<dynamic> postWithUrl(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().post(
      path,
      data: data,
      options: options,
    );
  }

  Future<dynamic> putWithUrl(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().put(
      path,
      data: data,
      options: options,
    );
  }

  Future<dynamic> deleteWithUrl(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().delete(
      path,
      data: data,
      options: options,
    );
  }

  Future<dynamic> patchWithUrl(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().patch(
      path,
      data: data,
      options: options,
    );
  }
}

@injectable
class BaseDioV2 {
  // khởi tạo biến
  Dio? _instance;

  //method for getting dio instance
  Dio _dio() {
    _instance = _createDioInstance();
    return _instance!;
  }

  var headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json',
  };

  Dio _createDioInstance() {
    late Dio dio;
    // final token = AppSharedPreference.instance.getValue(PrefKeys.token);
    // var header = headers;
    // if (token != null) header = {...headers, 'authorization': 'Bearer $token'};
    dio = Dio(BaseOptions());
    dio.interceptors.clear();
    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // options.headers['workspace-id'] = getCompanyId;
            return handler.next(options);
          },
          onResponse: (response, handler) {
            if (response.data != null && response.data['code'] == 403) {
              response.data['message'] =
                  'Bạn không có quyền truy cập chức năng này.${kDebugMode ? ' (${response.data['message']})' : ''}';
            }
            return handler.next(response);
          },
          onError: (error, handler) async {
            // const int count = 1;
            String msg = 'Có lỗi hệ thống, vui lòng thử lại';
            if (error.response?.data is Map) {
              msg = error.response?.data['message'] ??
                  'Có lỗi hệ thống, vui lòng thử lại';
            }

            error = error.copyWith(
              //error: msg,
              message: msg,
            );
            // print(error.response);
            if ((error.response?.statusCode == 401 ||
                    error.response?.statusCode == 403) &&
                error.response?.data['detail'] != 'User not found') {
              final accessToken = await _getNewToken();
              if (accessToken.isEmpty) {
                return handler.next(error);
              } else {
                _saveTokenToStorage(accessToken);

                // Thử lại yêu cầu gốc
                final RequestOptions requestOptions = error.requestOptions;
                final opts = Options(method: requestOptions.method);
                // dio.options.headers['Authorization'] = 'Bearer $accessToken';
                dio.options.headers['Accept'] = '*/*';
                final response = await dio.request(
                  requestOptions.path,
                  options: opts,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                );
                return handler.resolve(response);
              }
            } else {
              return handler.next(error);
            }
          },
        ),
        PrettyDioLogger(requestBody: true),
        CurlLoggerDioInterceptor(
          printOnSuccess: true,
        ),
      ],
    );
    return dio;
  }

  Future<String> _getNewToken() async {
    try {
      final payload = {
        'refresh':
            '${AppSharedPreference.instance.getValue(PrefKeys.tokenRefresh)}',
      };
      final res = await Dio(BaseOptions(headers: headers))
          .post('$baseURL/${Api.refreshToken}', data: payload);

      print(res.data['details']['access_token']);

      return res.data['details']['access_token'] ?? '';
    } catch (e) {
      return '';
    }
  }

  void _saveTokenToStorage(String token) {
    AppSharedPreference.instance.setValue(PrefKeys.token, token);
  }

// var dio = Dio(
//   BaseOptions(
//     headers: {
//       "authorization":
//           "Bearer ${AppSharedPreference.instance.getValue(PrefKeys.TOKEN)}",
//       "content-Type": "application/json",
//       "accept": "application/json",
//     },
//   ),
// );

  static String baseURL = 'https://e-tax-hub.too.onl';

  Future<dynamic> get(String path, {Map<String, dynamic>? data}) async {
    return _dio().get('$baseURL/$path', queryParameters: data);
  }

  Future<dynamic> post(String path, {Object? data}) async {
    return _dio().post('$baseURL/$path', data: data);
  }

  Future<dynamic> put(String path, {Object? data}) async {
    return _dio().put('$baseURL/$path', data: data);
  }

  Future<dynamic> delete(String path, {Object? data}) async {
    return _dio().delete('$baseURL/$path', data: data);
  }

  Future<dynamic> patch(String path, {Object? data}) async {
    return _dio().patch('$baseURL/$path', data: data);
  }
}

@injectable
class BaseDioAI {
  // khởi tạo biến
  Dio? _instance;

  //method for getting dio instance
  Dio _dio() {
    _instance = _createDioInstance();
    return _instance!;
  }

  var headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json',
  };

  Dio _createDioInstance() {
    late Dio dio;

    dio = Dio(BaseOptions());
    dio.interceptors.clear();
    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.next(options);
          },
          onResponse: (response, handler) {
            if (response.data != null && response.data['code'] == 403) {
              response.data['message'] =
                  'Bạn không có quyền truy cập chức năng này.${kDebugMode ? ' (${response.data['message']})' : ''}';
            }
            return handler.next(response);
          },
          onError: (error, handler) async {
            // const int count = 1;
            String msg = 'Có lỗi hệ thống, vui lòng thử lại';
            if (error.response?.data is Map) {
              msg = error.response?.data['message'] ??
                  'Có lỗi hệ thống, vui lòng thử lại';
            }

            error = error.copyWith(
              message: msg,
            );
            return handler.next(error);
          },
        ),
        PrettyDioLogger(requestBody: true),
        CurlLoggerDioInterceptor(printOnSuccess: true),
      ],
    );
    return dio;
  }

  static String baseURL = 'https://pharmago-invoice-ai.too.onl/api';

  Future<dynamic> get(String path, {Map<String, dynamic>? data}) async {
    return _dio().get('$baseURL/$path', queryParameters: data);
  }

  Future<dynamic> post(String path, {Object? data}) async {
    return _dio().post('$baseURL/$path', data: data);
  }

  Future<dynamic> put(String path, {Object? data}) async {
    return _dio().put('$baseURL/$path', data: data);
  }

  Future<dynamic> delete(String path, {Object? data}) async {
    return _dio().delete('$baseURL/$path', data: data);
  }

  Future<dynamic> patch(String path, {Object? data}) async {
    return _dio().patch('$baseURL/$path', data: data);
  }
}
