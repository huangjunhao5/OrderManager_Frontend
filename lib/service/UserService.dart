import 'package:dio/dio.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../Exception/HttpException/PermissionDeniedException.dart';
import '../pojo/User.dart';


const String LOGIN_TYPE = '/user/login';
const String REGISTER_SERVICE = "/user";

FormData fromUser(User user){
  return FormData.fromMap({
    'username': user.username,
    'password': user.password,
  });
}

Future<bool> UserService(User user, String type) async {
  var userDate = fromUser(user);
  try{
    var response = await request.postRequest(type, userDate);
    // print(response);
    if (response.statusCode == ok) {
      var result = response.data;
      if(result['code'] == ok){
        // 将token存入本地
        var token = result['data']['token'];
        // print(token);
        var userType = result['data']['type'];
        await request.saveToken(token);
        await request.saveCookie("username", user.username);
        await request.setInt('type', userType);
        return true;
      }
    }
    return false;
  }catch(e){
    print(e);
    // return false;
    // rethrow;
    throw setException(e);
  }
}



Future<bool> register(User user) async {
  bool flag = await UserService(user, REGISTER_SERVICE);
  return flag;
}


Future<bool> login(User user) async {
  bool flag = await UserService(user, LOGIN_TYPE);
  return flag;
}

Future logout() async {
  await request.cleanCookie('username');
  await request.cleanCookie('type');
  await request.cleanToken();
}

Future changePassword(User user) async {
  var userData = fromUser(user);
  try{
    var response = await request.putRequest('/user', userData);
    if(response.statusCode == ok){
      var res = response.data;
      print(res);
      if(res['code'] == ok){
        return ok;
      }else if(res['code'] == Unauthorized){
        throw PermissionDeniedException();
      }else{
        return false;
      }
    }
  }catch(e){
    print(e);
    throw setException(e);
  }
  return err;
}

// 用户列表，需要root权限
// ignore: non_constant_identifier_names
Future ListUser() async {
  try{
    var response = await request.getRequest('/user');
    if(response.statusCode == ok){
      var res = response.data;
      if(res['code'] == ok){
        return res['data'];
      }else if(res['code'] == Unauthorized){
        throw PermissionDeniedException();
      }else{
        throw Exception();
        // 未知错误
      }
    }
    return null;
  }catch(e){
    throw setException(e);
  }
}


Future getUserType() async {
  return await request.getInt('type');
}


Future getUsername() async{
  return await request.getString('username');
}

Future submitUserType(String username, int type) async {
  FormData data = FormData.fromMap({
    'username': username,
    'type': type,
  });
  try{
    var response = await request.putRequest('/user/admin', data);
    if(response.statusCode == ok){
      var res = response.data;
      var code = res['code'];
      if(code == Unauthorized){
        throw PermissionDeniedException();
      }
      return code;
    }
  }catch(e){
    throw setException(e);
  }
}


// 根据id删除用户
Future deleteUser(int id) async {
  try{
    var response = await request.deleteRequest('/user/$id');
    if(response.statusCode == Unauthorized){
      throw PermissionDeniedException();
    }
    else if(response.statusCode == ok){
      var res = response.data;
      return res['code'];
    }
    return err;
  }catch(e){
    throw setException(e);
  }
}

