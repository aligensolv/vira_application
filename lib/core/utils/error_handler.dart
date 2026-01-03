import 'package:dio/dio.dart';

class DioErrorUtil {
  static String getErrorMessage(DioException error) {
    // 1️⃣ لو السيرفر رجع response
    if (error.response != null) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        // شكل response عندك
        // {"success":false,"status":500,"error":{"message":"Place is not available at this time","code":"INTERNAL_SERVER_ERROR","errors":[]}}
        final errorData = data['error'];
        if (errorData != null && errorData['message'] != null) {
          return errorData['message'];
        }
      }

      // fallback لو شكل غير متوقع
      return "Server Error: ${error.response?.statusCode}";
    } 

    // 3️⃣ fallback عام
    return "Something went wrong";
  }
}
