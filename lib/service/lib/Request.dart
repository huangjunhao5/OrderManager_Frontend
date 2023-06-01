
// import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_course_design/service/UserService.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Exception/HttpException/ConnectErrorException.dart';
import '../../Exception/HttpException/PermissionDeniedException.dart';

const ok = 200;
const err = 201;
const Unauthorized = 401;
const serverError = 500;



const String tokenKey = 'token';
const String baseUrlKey = 'baseUrl';
String baseUrl = ''; // 替换为实际的 API 基础 URL

// ignore: constant_identifier_names
const String ConnectionError = "服务器连接异常，请重试";
// ignore: constant_identifier_names
const String PermissionDenied = "你没有足够的权限访问该资源,请重新登录";

// ignore: constant_identifier_names
const String LoginExpired = "登录过期，请重新登录";


class RequestService {
  final Dio _dio = Dio();


  Future<Response> getRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      endpoint = baseUrl + endpoint;
      // print("Request url: $endpoint");
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: await _getOptions(),
      );
      updateToken(response.headers.map);
      return response;
    } catch (e) {
      // 处理 Dio 异常
      // print(e);
      throw setException(e);
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data,
      {bool isFormData = false}) async {
    try {
      endpoint = baseUrl + endpoint;
      final options = await _getOptions(isFormData: isFormData);
      final response = await _dio.post(endpoint, data: data, options: options);
      updateToken(response.headers.map);
      return response;
    } catch (e) {
      // 处理 Dio 异常
      // print(e);
      throw setException(e);
    }
  }

  Future<Response> putRequest(String endpoint, dynamic data,
      {bool isFormData = false}) async {
    try {
      endpoint = baseUrl + endpoint;

      final options = await _getOptions(isFormData: isFormData);

      final response = await _dio.put(endpoint, data: data, options: options);
      updateToken(response.headers.map);
      // print(endpoint);
      return response;
    } catch (e) {
      // 处理 Dio 异常
      // print(e);
      throw setException(e);
    }
  }

  Future<Response> deleteRequest(String endpoint, {
    dynamic? data
  }) async {
    try {
      endpoint = baseUrl + endpoint;
      final options = await _getOptions();
      final response = await _dio.delete(endpoint, options: options);
      updateToken(response.headers.map);
      return response;
    } catch (e) {
      // 处理 Dio 异常
      // print(e);
      throw setException(e);
    }
  }

  Future<Options> _getOptions({bool isFormData = false}) async {
    final options = Options();
    options.headers = {};

    final token = await getToken();
    // print(token);
    if (token != null) {
      options.headers!['token'] = token;
    }

    if (isFormData) {
      options.headers!['Content-Type'] = 'application/x-www-form-urlencoded';
    }else{
      options.headers!['Content-Type'] = 'application/json';
    }

    return options;
  }
  Future updateToken(Map<String, dynamic> headers) async {
    if (headers.containsKey('Authorization')) {
      // print("new token:${headers['Authorization'][0]}");
      String token = headers['Authorization'][0];
      await saveToken(token);
      // print('Token: $token');
    } else {
      print('未找到Token');
    }
  }
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  Future<void> saveCookie(String key, String val) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<bool> saveBaseUrl(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = url;
    preferences.setString(baseUrlKey, url);
    return true;
  }
  Future<void> initBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString(baseUrlKey);
    baseUrl = (temp ?? '');
  }
  Future<void> cleanCookie(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
  Future<void> cleanToken() async {
    await cleanCookie(tokenKey);
  }
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<void> setString(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }
  Future<void> setBool(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }
  Future<void> setInt(String key, int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }
}

Exception setException(e){
  if(e is DioError){
    int? statusCode = e.response?.statusCode;
    if(statusCode == Unauthorized){
      // 没有权限或登录过期，自动触发登出
      print("$PermissionDenied，已经自动登出！");
      logout();
      throw PermissionDeniedException();
    }else{
      throw ConnectErrorException();
    }
  }
  else {
    return Exception(e.toString());
  }

}


var request = RequestService();

Future<bool> test(String url) async {
  String temp = baseUrl;
  baseUrl = url;
  bool flag = false;
  try{
    var response = await request.getRequest('/test');
    if(response.statusCode == ok){
      var data = response.data;
      print(data);
      if(data['code'] == ok){
        flag = true;
      }
    }
  }catch(e){
    print(e.toString());
    baseUrl = temp;
    return flag;
  }
  baseUrl = temp;
  return flag;
}
