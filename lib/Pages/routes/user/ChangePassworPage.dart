import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Components/GestureDetectorContainer.dart';
// import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/Components/PasswordTextField.dart';
import 'package:flutter_course_design/service/UserService.dart';
import 'package:flutter_course_design/service/lib/Request.dart';
// import 'package:flutter_course_design/Components/ListViewContainer.dart';

import '../../../Components/DefaultTextField.dart';
import '../../../pojo/User.dart';

// 更改密码页面：需要得到需要更改密码到用户名才能继续
class _ChangePasswordPageBuild extends State<ChangePasswordPage> {
  // String username;
  String newPassword = '';
  String curPassword = '';

  bool locked = false;

  // 提交修改密码请求的函数
  Future submit() async {
    if (locked) return;
    // 校验数据是否合法，如果不合法跳过提交以提高运行效率
    if (!checkInput()) return;
    locked = true;
    setState(() {});
    // 调用接口，提交数据
    try {
      int flag = await changePassword(
          User(username: widget.username, password: newPassword));
      if (flag == ok) {
        if (mounted) {
          await PromptDialogFactory.create(context, '修改成功', '修改密码成功！');
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          throw err;
        }
      } else {
        throw flag;
      }
    } catch (e) {
      if (e == Unauthorized) {
        await PromptDialogFactory.create(context, '操作失败', PermissionDenied);
      } else {
        await PromptDialogFactory.create(context, '操作失败', ConnectionError);
      }
    }
    locked = false;
    setState(() {});
  }

  bool checkInput() {
    if (newPassword.length < 6) return false;
    if (curPassword != newPassword) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultRouteAppBar(
        title: '修改密码',
        context: context,
        actions: [IconButton(onPressed: submit, icon: const Icon(Icons.check))],
      ),
      body: GestureDetectorContainer(
        context: context,
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            ListTile(
              title: DefaultTextField(
                enabled: false,
                text: widget.username,
                decoration: const InputDecoration(
                  labelText: "用户名",
                ),
              ),
            ),
            ListTile(
              title: PasswordTextField(
                labelText: '新密码',
                onChange: (text) {
                  newPassword = text ?? '';
                },
                validator: (text) {
                  if (text != null && text != '' && text.length < 6) {
                    return '密码长度至少为6位';
                  }
                  return null;
                },
              ),
            ),
            ListTile(
              title: PasswordTextField(
                onChange: (text) {
                  curPassword = text ?? '';
                },
                labelText: "确认密码",
                validator: (text) {
                  if (text != newPassword) {
                    return '请再次输入密码';
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: ListTile(
                title: buildButton(context, locked ? "正在修改" : "修改密码", () {
                  submit();
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  _ChangePasswordPageBuild() : super() {
    // TODO: implement _ChangePasswordPageBuild
  }
}

class ChangePasswordPage extends StatefulWidget {
  String username;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangePasswordPageBuild();
  }

  ChangePasswordPage({required this.username, super.key}) : super();
}
