import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/GestureDetectorContainer.dart';
import 'package:flutter_course_design/Pages/routes/user/LoginPage.dart';
import 'package:flutter_course_design/pojo/User.dart';

import '../../../Components/BackButton.dart';
import '../../../Components/Button.dart';
import '../../../Components/Dialog.dart';
import '../../../service/UserService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  final String title = "注册";

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String curPassword = '';
  bool _isObscure = true;
  bool _isObscured = true;
  Color _eyeColor = Colors.grey;
  bool locked = false;
  // 登录页面主体
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // 设置globalKey，用于后面获取FormStat
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: GestureDetectorContainer(
          context: context,
          child: Column(children: [
            const SizedBox(height: kToolbarHeight),
            buildBackButton(context, isAppBar: false), // 返回按钮
            Expanded(
                child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: kToolbarHeight / 4), // 距离顶部一个工具栏的高度
                buildTitle(),
                const SizedBox(height: 60),
                buildUsernameTextField(), // 输入用户名
                const SizedBox(height: 30),
                buildPasswordTextField(context), // 输入密码
                const SizedBox(height: 30),
                buildCurPasswordTextField(context),
                // buildForgetPasswordText(context), // 忘记密码
                const SizedBox(height: 60),
                buildButton(context, locked ? "正在注册" : "注册", () async {
                  if (locked) {
                    // print("locked, can't press");
                    return;
                  }
                  if (curPassword != password) {
                    // 提示两次输入的密码不一致
                    PromptDialogFactory.create(context, "注册失败", "两次输入的密码不一致");
                    return;
                  }
                  try {
                    // 执行按钮点击事件前，先对按钮进行上锁操作
                    locked = true;
                    setState(() {});
                    User user = User(username: username, password: password);
                    bool flag = await register(user);
                    if (flag) {
                      await PromptDialogFactory.create(context, '提示', "注册成功");
                      Navigator.pop(context);
                    } else {
                      PromptDialogFactory.create(context, '注册失败', '用户名已经存在！');
                    }
                  } catch (e) {
                    PromptDialogFactory.create(context, '注册失败', '服务器连接错误，请重试！');
                  }
                  // 点击事件执行结束后，解锁按钮
                  locked = false;
                  setState(() {});
                }), // 登录按钮
                const SizedBox(height: 40),
                buildLoginText(context), // 注册
              ],
            ))
          ]),
        ),
      ),
    );
  }

  Widget buildLoginText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('已有账号?'),
            GestureDetector(
              child: const Text('点击登录', style: TextStyle(color: Colors.green)),
              onTap: () {
                // print("点击注册");
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscure, // 是否显示文字
        onSaved: (v) {
          password = v!;
        },
        onChanged: (String v) {
          password = v;
        },
        validator: (v) {
          if (v!.isEmpty) {
            return '请输入密码';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "密码",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = (_isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildCurPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscured, // 是否显示文字
        onSaved: (v) {
          curPassword = v!;
        },
        onChanged: (String v) {
          curPassword = v;
        },
        validator: (v) {
          if (v!.isEmpty) {
            return '请重新输入密码';
          }
          if (v! != password) {
            return "两次输入密码不一致";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "确认密码",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                setState(() {
                  _isObscured = !_isObscured;
                  _eyeColor = (_isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildUsernameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: '用户名'),
      validator: (v) {
        if (v == null || v.length == 0) {
          return "请输入用户名";
        }
        return null;
      },
      onSaved: (v) {
        username = v!;
      },
      onChanged: (String v) {
        username = v;
      },
    );
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 42),
        ));
  }
}
