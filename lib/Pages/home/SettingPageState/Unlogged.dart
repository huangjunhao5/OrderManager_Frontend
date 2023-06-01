
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';

import 'package:flutter_course_design/service/lib/Request.dart';
import '../../routes/user/LoginPage.dart';


class _UnLoggedComponentsBuild extends State<UnLoggedComponents>{
  _UnLoggedComponentsBuild():super();
  @override
  Widget build(BuildContext ct) {
    // TODO: implement build
    return Column(
      children: [
        const SizedBox(height: 100,),
        buildButton(context, "登录", () async {
          await Navigator.push(
              widget.context, MaterialPageRoute(builder: (context) => const LoginPage()));
          String? token = await request.getToken();
          widget.setLoginFlag(token == null ? false : true);
        })
      ],
    );
  }
}






class UnLoggedComponents extends StatefulWidget{
  BuildContext context;
  UnLoggedComponents({super.key, required this.context, required this.setLoginFlag});
  void Function(bool) setLoginFlag;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UnLoggedComponentsBuild();
  }
}



