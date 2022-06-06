import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ScpHttpClient {
  static const String _baseUrl = 'mmgg.kr';
  static var TOKEN = '';
  static Future<void> get(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
  }) async {

    // var naver = Uri.http('httpbin.org', '/ip');
    // var response2 = await http.get(naver);
    // print(response2.body);

    var url = Uri.https(
      _baseUrl,
      detailUrl,
    );

    String token = 'Bearer $TOKEN';

    headers = headers ?? {
      HttpHeaders.authorizationHeader:token,
    };

    Fluttertoast.showToast(
        msg:'request server $token',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    // headers['content-type'] = 'application/json';

    print(headers);
    print(url);
    var response = await http.get(url, headers: headers);
    print('코드 : ${response.statusCode}');
    // if (response.statusCode >= 200 && response.statusCode < 300) {
    Map<String, dynamic> json = convert.jsonDecode(response.body);
    print(json);
    int status = json['status'];
    String msg = json['message'];
    if (status >= 200 && status < 300) {
      Map<String, dynamic> result = json['result'];
      onSuccess(result, msg);
    } else {
      onFailed(msg);
    }
  }

  static Future<void> post(
    String detailUrl, {
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    Map<String, String>? headers,
    Object? body,
  }) async {
    var url = Uri.https(
      _baseUrl,
      detailUrl,
    );

    String token = '';


    token = 'Bearer ';
    token += token;

    if(headers != null) headers['Authorization'] = token;
    headers ??= {'Content-Type': 'application/json','Authorization':token};
    String? jsonBody;
    if (body != null) jsonBody = json.encode(body);
    var response = await http.post(url, headers: headers, body: jsonBody);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        onSuccess(json, msg);
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
    var url = Uri.https(
      _baseUrl,
      detailUrl,
    );
    // headers ??= {'Content-Type': 'application/json'};
    String? jsonBody;
    if (body != null) jsonBody = json.encode(body);
    var response = await http.patch(url, headers: headers, body: jsonBody);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        onSuccess(json, msg);
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
    var url = Uri.https(
      _baseUrl,
      detailUrl,
    );
    headers ??= {'Content-Type': 'application/json'};
    String jsonBody = '';
    if (body != null) jsonBody = json.encode(body);
    var response = await http.delete(url, headers: headers, body: jsonBody);
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
    var url = Uri.https(
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
