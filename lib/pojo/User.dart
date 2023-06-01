

class User {
  String username = "";
  String password = "";
  User({required this.username, required this.password});
  static const int superAdmin = 0;
  static const int admin = 1;
  static const int user = 2;
  static String getType(int type){
    if(type == superAdmin){
      return "超级管理员";
    }else if(type == admin){
      return "管理员";
    }else{
      return "普通用户";
    }
  }
}