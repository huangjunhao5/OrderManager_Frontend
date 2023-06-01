

import 'package:flutter_course_design/service/lib/Request.dart';

import 'HttpException.dart';

class TokenException extends HttpException{
  TokenException() : super(){
    message = "token已过期";
    statusCode = Unauthorized;
  }
}