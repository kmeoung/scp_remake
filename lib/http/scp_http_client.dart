import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class ScpHttpClient {
  static const String _baseUrl = 'mmgg.kr';

  static Future<void> get(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
  }) async {
    var url = Uri.http(
      _baseUrl,
      detailUrl,
    );
    var response = await http.get(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      onFailed('server connected failed');
    }
  }

  static Future<void> post(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
    Object? body,
  }) async {
    var url = Uri.http(
      _baseUrl,
      detailUrl,
    );
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(response.body);
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      onFailed('server connected failed');
    }
  }

  static Future<void> patch(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
    Object? body,
  }) async {
    var url = Uri.http(
      _baseUrl,
      detailUrl,
    );
    var response = await http.patch(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      onFailed('server connected failed');
    }
  }

  static Future<void> delete(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
    Object? body,
  }) async {
    var url = Uri.http(
      _baseUrl,
      detailUrl,
    );
    var response = await http.delete(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      onFailed('server connected failed');
    }
  }

  static Future<void> put(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
    Object? body,
  }) async {
    var url = Uri.http(
      _baseUrl,
      detailUrl,
    );
    var response = await http.put(url, headers: headers, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      onFailed('server connected failed');
    }
  }
}
