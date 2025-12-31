import 'package:dio/dio.dart';

abstract class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  final Pagination? pagination;

  const ApiSuccess(this.data, {this.pagination});
}

class Pagination {
  final int? currentPage;
  final int? totalPages;
  final int? pageSize;
  final int? totalItems;

  const Pagination({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalItems,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? json['page'] ?? 1,
      totalPages: json['total_pages'] ?? json['pages'],
      pageSize: json['page_size'] ?? json['limit'],
      totalItems: json['total_items'] ?? json['total'],
    );
  }
}

class ApiError<T> extends ApiResult<T> {
  final String message;
  final int? code;
  final String? status;
  final List<dynamic>? details;
  final dynamic error;

  const ApiError({
    required this.message,
    this.code,
    this.status,
    this.details,
    this.error,
  });

  factory ApiError.fromResponse(Response<dynamic> response) {
    return ApiError(
      message: response.data['message'] ?? response.statusMessage ?? '',
      code: response.data['code'] ?? response.statusCode,
      status: response.data['status'],
      details: response.data['details'],
      error: response.data,
    );
  }
}

class ValidationError<T> extends ApiError<T> {
  const ValidationError({
    List<dynamic>? details,
  }) : super(
          message: "Validation failed",
          code: 422, // Use your VALIDATION_ERROR_CODE
          status: "BAD_REQUEST", // Use your BAD_REQUEST_STATUS
          details: details,
        );
}

class AuthError<T> extends ApiError<T> {
  const AuthError({
    String message = "Unauthorized",
  }) : super(
          message: message,
          code: 401, // Use your AUTH_ERROR_CODE
          status: "NOT_AUTHORIZED", // Use your NOT_AUTHORIZED_STATUS
        );
}

class DuplicationError<T> extends ApiError<T> {
  const DuplicationError({
    String message = "Data is duplicated",
  }) : super(
          message: message,
          code: 409, // Use your DUPLICATION_ERROR_CODE
          status: "ALREADY_EXISTS", // Use your ALREADY_EXISTS_STATUS
        );
}

class BadRequestError<T> extends ApiError<T> {
  const BadRequestError({
    String message = "Bad Request",
  }) : super(
          message: message,
          code: 400, // Use your BAD_REQUEST_CODE
          status: "BAD_REQUEST", // Use your BAD_REQUEST_STATUS
        );
}
