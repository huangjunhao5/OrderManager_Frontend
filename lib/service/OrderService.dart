

import 'package:dio/dio.dart';

import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/pojo/Order.dart';
import 'package:flutter_course_design/service/lib/Request.dart';


// ignore: non_constant_identifier_names
Future MultiOrderServiceBase(String url) async {
  try{
    var response =
    await request.getRequest(url);
    if(response.statusCode == ok){
      var res = response.data;
      if(res['code'] == Unauthorized){
        throw PermissionDeniedException();
      }
      if(res['code'] == err){
        throw ConnectErrorException();
      }
      // 返回响应结果
      return res['data'];
    }else if(response.statusCode == Unauthorized){
      throw PermissionDeniedException();
    }else{
      throw ConnectErrorException();
    }
  }catch(e){
    throw setException(e);
  }
}


Future getAllCreatedOrderInfo() async {
  return await MultiOrderServiceBase('/order/type/${OrderInfo.CreatedFlag}');
}

Future getAllOrderInfo() async {
  return await MultiOrderServiceBase('/order');
}

Future getOrder(int id) async {
  try{
    var response = await request.getRequest('/order/$id');
    if(response.statusCode == ok){
      var res = response.data;
      // print(res);
      if(res['code'] == ok){
        return res['data']['orderLists'];
      }else if(res['code'] == Unauthorized){
        throw PermissionDeniedException();
      }else{
        throw ConnectErrorException();
      }
    }
  }catch(e){
    print(e);
    throw setException(e);
  }
}


Future cancerOrder(int id) async {
  var response = await request.deleteRequest('/order/$id');
  if(response.statusCode == ok) {
    var res = response.data;
    if(res['code'] == err){
      throw ConnectErrorException();
    }
    if(res['code'] == Unauthorized){
      throw PermissionDeniedException();
    }
    return true;
  }
  if(response.statusCode == err){
    throw ConnectErrorException();
  }
  if(response.statusCode == Unauthorized){
    throw PermissionDeniedException();
  }
}

Future doOrder(int id) async {
  try{
    var response = await request.putRequest('/order/$id', FormData.fromMap({
      'type': OrderInfo.EndFlag,
    }));
    if(response.statusCode == err){
      throw ConnectErrorException();
    }
    if(response.statusCode == Unauthorized){
      throw PermissionDeniedException();
    }
    var res = response.data;
    if(res['code'] == ok){
      return true;
    }else {
      throw ConnectErrorException();
    }
  }catch(e){
    throw setException(e);
  }
}


Future createOrder(Order order) async {
  var response = await request.postRequest('/order', order);
  if(response.statusCode == err)throw ConnectErrorException();
  if(response.statusCode == Unauthorized) throw PermissionDeniedException();
  var res = response.data;
  print(res);
  if(res['code'] == Unauthorized)throw PermissionDeniedException();
  if(res['code'] == err) throw ConnectErrorException();
  return true;
}

