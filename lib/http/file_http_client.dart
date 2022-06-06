import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileHttpClient {
  static const String _baseUrl = 'https://mmgg.kr';

  // 1개의 파일 업로드
  Future<void> uploadFile({
    required int pid,
    required int tid,
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
  }) async {
    // file picker를 통해 파일 선택
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final filePath = result.files.single.path;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData =
          FormData.fromMap({'file': await MultipartFile.fromFile(filePath!)});

      // 업로드 요청
      final response =
          await dio.post('$_baseUrl/fileupload/$pid/$tid', data: formData);
      // if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> json = jsonDecode(response.data);
      print(json);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  static Future<List<String?>?> selectFiles() async{
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    return result?.paths;
  }

  // 여러개의 파일 업로드
  static Future<void> uploadFiles({
    required int pid,
    required int tid,
    required Function(Map<String, dynamic> json, String message) onSuccess,
    required Function(String message) onFailed,
    required List<String?> filePaths,
  }) async {

    if (filePaths.isNotEmpty) {

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'files': List.generate(filePaths.length,
            (index) => MultipartFile.fromFileSync(filePaths[index]!))
      });

      // 업로드 요청
      final response =
          await dio.post('$_baseUrl/fileupload/$pid/$tid', data: formData);
      Map<String, dynamic> json = jsonDecode(response.data);
      print(json);
      int status = json['status'];
      String msg = json['message'];
      if (status >= 200 && status < 300) {
        Map<String, dynamic> result = json['result'];
        onSuccess(result, msg);
      } else {
        onFailed(msg);
      }
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }
}
