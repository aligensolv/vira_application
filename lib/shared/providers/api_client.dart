import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vira/core/network/interceptors/auth_interceptor.dart';
import 'package:vira/core/network/interceptors/client_source_interceptor.dart';
import 'package:vira/core/services/cache_service.dart';
import '../../core/config/app_constants.dart';
import '../../core/network/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConstants.apiUrl,
    interceptors: [
      AuthInterceptor(
        getToken: () async => CacheService.getString('access_token'),
      ),
      ClientSourceInterceptor()
    ]
  );
});