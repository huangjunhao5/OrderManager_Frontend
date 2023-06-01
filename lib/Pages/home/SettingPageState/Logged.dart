import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
// import 'package:flutter_course_design/Components/BackButton.dart';
import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/Pages/routes/user/ChangePassworPage.dart';
import 'package:flutter_course_design/Pages/routes/user/UserInfo.dart';
import 'package:flutter_course_design/Pages/routes/user/UserManagePage.dart';
// import 'package:flutter_course_design/Pages/routes/user/LoginPage.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../../../Components/Button.dart';
import '../../../pojo/User.dart';
import '../../../service/UserService.dart';

class LoggedComponents extends StatefulWidget {
  final BuildContext context;
  final void Function(bool) setLoginFlag;
  const LoggedComponents(
      {super.key, required this.context, required this.setLoginFlag})
      : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoggedComponentsBuild();
  }
}

class _LoggedComponentsBuild extends State<LoggedComponents> {
  _LoggedComponentsBuild() : super();

  String username = '';

  int type = 2;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    username = (await request.getString('username'))!;
    type = (await request.getInt('type'))!;
    setState(() {});
  }

  Widget isRoot() {
    if (type == User.superAdmin) {
      return ListItem(
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserManagePage()));
          },
          title: "用户管理");
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext ct) {
    // TODO: implement build
    return Column(
      children: [
        ListItem(
            onPress: () {
              // 跳转到修改密码页面
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangePasswordPage(username: username)));
              // print("修改密码");
            },
            title: "修改密码"),
        const SizedBox(
          height: 140,
        ),
        SizedBox(
          height: type == User.superAdmin ? 0 : 20,
        ),
        const Divider(
          height: 1,
        ),
        isRoot(),
        ListItem(
          onPress: () {
            // 用户详情页跳转
            // print("user info");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UserInfo(username: username, userType: type)));
          },
          title: "已登录用户：$username",
        ),
        const SizedBox(
          height: 30,
        ),
        buildButton(context, "退出登录", () async {
          //跳转登录界面
          ConfirmDialogFactory.create(context, '提示', "你确定要退出登录吗？", () async {
            await logout();
            widget.setLoginFlag(false);
          });
        }),
      ],
    );
  }
}
