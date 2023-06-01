import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Pages/routes/user/ChangePassworPage.dart';
import 'package:flutter_course_design/Pages/routes/user/ChangeUserInfoPage.dart';
import 'package:flutter_course_design/service/UserService.dart';

import '../../../pojo/User.dart';

class UserInfoBuild extends State<UserInfo> {
  int? loginUserType;
  // ignore: non_constant_identifier_names
  Widget? ChangeUserType(BuildContext context) {
    if (loginUserType != User.superAdmin) {
      return null;
    }
    if (widget.userType == User.superAdmin) {
      return null;
    }
    return buildButton(context, '修改用户信息', () async {
      // print("修改用户信息");
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeUserInfoPage(
                    username: widget.username,
                    type: widget.userType,
                    getNowType: (nowType) {
                      widget.userType = nowType;
                    },
                  )));
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future _initState() async {
    loginUserType = await getUserType();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: "用户详情",
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Center(
            child: Text(
              widget.username,
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              User.getType(widget.userType),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          buildButton(context, '修改密码', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChangePasswordPage(username: widget.username)));
          }),
          const SizedBox(
            height: 10,
          ),
          ChangeUserType(context) ??
              const SizedBox(
                height: 0,
              ),
        ],
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  String username;
  int userType;
  @override
  State createState() {
    return UserInfoBuild();
  }

  UserInfo({super.key, required this.username, required this.userType});
}
