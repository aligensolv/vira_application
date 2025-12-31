import 'package:dio/dio.dart';

class ClientSourceInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['x-client-source'] = 'mobile-app';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Optionally handle 401 errors here
    super.onError(err, handler);
  }
}