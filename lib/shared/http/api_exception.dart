import 'package:dio/dio.dart';
import 'dart:io';

class ApiException implements Exception {
  late String message;

  ApiException.fromDioError(DioError dioError) {
    if (dioError.error is SocketException) {
      message = "No Internet Connection";
    } else if (dioError.type == DioErrorType.connectionTimeout) {
      message = "Connection timeout with API server";
    } else if (dioError.type == DioErrorType.receiveTimeout) {
      message = "Receive timeout in connection with API server";
    } else if (dioError.type == DioErrorType.sendTimeout) {
      message = "Send timeout in connection with API server";
    } else if (dioError.type == DioErrorType.badResponse) {
      message = _handleError(
        dioError.response?.statusCode,
        dioError.response?.data,
        dioError.response?.statusMessage,
      );
    } else {
      message = "Unexpected error occurred";
    }
  }

  String _handleError(int? statusCode, dynamic error, String? message) {
    switch (statusCode) {
      case 400:
        return /*message ??*/ "Bad Request";
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['error'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
     /* case 503:
        return 'Oops something went wrong';*/
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}

/*
import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException.fromDioError(DioError dioError) {
    switch (dioError.error) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.unknown:
        if (dioError.message==("SocketException")) {
          message = 'No Internet';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  late String message;

  @override
  String toString() => message;

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['error'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }
}*/
