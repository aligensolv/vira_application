// filepath: e:/workspace/business_workspace/trusted/trusted_app/lib/core/network/interceptors/log_interceptor.dart
import 'package:dio/dio.dart';
import '../../utils/logger.dart';

class LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    pinfo(
      'REQUEST[${options.method}] => PATH: ${options.uri}',
      tag: 'DIO',
    );
    pdebug('Headers: ${options.headers}', tag: 'DIO');
    if (options.data != null) {
      pdebug('Body: ${options.data}', tag: 'DIO');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    pinfo(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}',
      tag: 'DIO',
    );
    pdebug('Data: ${response.data}', tag: 'DIO');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    perror(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}',
      tag: 'DIO',
    );
    if (err.response != null) {
      perror('Data: ${err.response?.data}', tag: 'DIO');
    }
    perror('Message: ${err.message}', tag: 'DIO');
    super.onError(err, handler);
  }
}