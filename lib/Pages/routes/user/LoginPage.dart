import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/GestureDetectorContainer.dart';
import 'package:flutter_course_design/pojo/User.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../../../Components/BackButton.dart';
import '../../../Components/Button.dart';
import '../../../Components/Dialog.dart';
import '../../../service/UserService.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  final String title = "登录";

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool _isObscure = true;
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
            buildBackButton(context, isAppBar: false),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(
                    height: kToolbarHeight / 4), // 距离顶部一个工具栏的高度// 距离顶部一个工具栏的高度
                buildTitle(), // Login
                const SizedBox(height: 60),
                buildUsernameTextField(), // 输入用户名
                const SizedBox(height: 30),
                buildPasswordTextField(context), // 输入密码
                buildForgetPasswordText(context), // 忘记密码
                const SizedBox(height: 60),
                buildButton(context, locked ? "正在登录" : "登录", () async {
                  if (locked) {
                    // print("locked ,can't press");
                    return;
                  }
                  if (username.isEmpty || password.isEmpty) {
                    print("skip");
                    return;
                  }
                  try {
                    locked = true;
                    setState(() {});
                    User user = User(username: username, password: password);
                    bool flag = await login(user);
                    if (mounted) {
                      if (flag) {
                        await PromptDialogFactory.create(context, '提示', "登录成功");
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        PromptDialogFactory.create(context, '登录失败', '用户或密码错误！');
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      PromptDialogFactory.create(
                          context, '登录失败', ConnectionError);
                    }
                  }
                  locked = false;
                  setState(() {});
                }), // 登录按钮
                const SizedBox(height: 40),
                buildRegisterText(context), // 注册
              ],
            ))
          ]),
        ),
      ),
    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('没有账号?'),
            GestureDetector(
              child: const Text('点击注册', style: TextStyle(color: Colors.green)),
              onTap: () {
                // print("点击注册");
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            // 弹出一个提示窗口
            PromptDialogFactory.create(context, '提示', "如果你忘记了密码，\n请联系管理员重置密码");
          },
          child: const Text("忘记密码？",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
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

  Widget buildUsernameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: '用户名'),
      validator: (v) {
        if (v == null) {
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
          'Login',
          style: TextStyle(fontSize: 42),
        ));
  }
}
