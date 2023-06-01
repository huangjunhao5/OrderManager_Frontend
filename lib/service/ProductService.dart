



import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/Pages/routes/order/NewOrderPage.dart';
import 'package:flutter_course_design/pojo/Product.dart';
import 'package:flutter_course_design/service/lib/Request.dart';




Future getAllProductInfo() async {
  var response = await request.getRequest('/storehouse');
  var res = response.data;
  if(res['code'] == Unauthorized)throw PermissionDeniedException();
  if(res['code'] == err) throw ConnectErrorException();
  return res['data'];
}

Future getProductById(int id) async {
  var response = await request.getRequest('/storehouse/$id');
  var res = response.data;
  if(res['code'] == Unauthorized) throw PermissionDeniedException();
  if(res['code'] == err) throw ConnectErrorException();
  return res['data'];
}

Future updateProduct(Product product) async {
  var response = await request.putRequest('/storehouse', product);
  var res = response.data;
  if(res['code'] == Unauthorized) throw PermissionDeniedException();
  if(res['code'] == err) throw Exception(res['msg']);
  return true;
}

Future createNewProduct(FormData product) async {
  var response = await request.postRequest('/storehouse', product);
  if(response.statusCode == err)throw ConnectErrorException();
  if(response.statusCode == Unauthorized)throw PermissionDeniedException();
  var res = response.data;
  if(res['code'] == err)throw ConnectErrorException();
  if(res['code'] == Unauthorized) throw PermissionDeniedException();
  return true;
}
