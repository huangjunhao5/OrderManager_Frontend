

import '../../service/lib/Request.dart';
import 'HttpException.dart';

class PermissionDeniedException extends HttpException{
  PermissionDeniedException(){
    message = PermissionDenied;
    statusCode = Unauthorized;
  }
}
