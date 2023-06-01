

import 'package:flutter_course_design/service/lib/Request.dart';

import 'HttpException.dart';

class ConnectErrorException extends HttpException{
  ConnectErrorException(){
    statusCode = err;
    message = ConnectionError;
  }
}