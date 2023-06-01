import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../../../Components/Button.dart';
import '../../../Components/Dialog.dart';

// 本页的输入框，用来输入服务器地址

var _serverText = TextField(
  controller: TextEditingController(),
  decoration: const InputDecoration(
    hintText: '请输入服务器地址',
  ),
);

class _ServerSettingPage extends State<StatefulWidget> {
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    _serverText.controller!.text = baseUrl;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // 初始化baseUrl
    // _serverText.controller!.text = baseUrl;
    return Scaffold(
      // appbar，本页特殊的appear，不使用通用appbar

      appBar: DefaultRouteAppBar(
        context: context,
        title: "修改服务器地址",
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 右侧按钮点击事件
              try {
                String url = _serverText.controller!.text;
                request.saveBaseUrl(url);
              } catch (e) {
                // 弹窗
                // print(e);
                return;
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        // alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // const Text("请输入服务器地址："),
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                ),
                child: _serverText,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                ),
                child:
                    buildButton(context, isLocked ? "正在连接" : "连接测试", () async {
                  if (isLocked) {
                    print("locked!");
                    return;
                  }
                  isLocked = true;
                  setState(() {});
                  // 连接测试

                  var temp = _serverText.controller;
                  var flag = await test(temp!.text);
                  String dialogTitle = flag ? "连接成功" : "连接失败";
                  String dialogBody =
                      "${temp.text}\n服务器${flag ? "连接成功！\nTest Passed" : "连接失败\nConnection Failed!"}";
                  // print(temp.text);
                  if (mounted) {
                    await PromptDialogFactory.create(
                        context, dialogTitle, dialogBody);
                  }
                  // 显示弹窗

                  isLocked = false;
                  if(mounted)setState(() {});
                  // 后续操纵
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 调用
class ServerSettingPage extends StatefulWidget {
  const ServerSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ServerSettingPage();
  }
}
