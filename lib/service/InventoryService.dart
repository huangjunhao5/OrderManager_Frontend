
import 'package:dio/dio.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

class InventoryFlags{
  static int add = 1;
  static int sub = 0;
}

Future changeStoreNum(int id, int num, int changeFlag) async {
  FormData formData = FormData.fromMap({
    'num': num,
    'changeFlag': changeFlag,
  });
  var response = await request.putRequest('/storehouse/$id', formData);
  if(response.statusCode == err)throw ConnectErrorException();
  if(response.statusCode == Unauthorized) throw PermissionDeniedException();
  var res = response.data;
  if(res['code'] == err)throw Exception(res['msg']);
  if(res['code'] == Unauthorized) throw PermissionDeniedException();
  return true;
}