import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Pages/routes/setting/ThemeSetting.dart';
import 'package:flutter_course_design/Pages/routes/user/LoginPage.dart';
import 'package:flutter_course_design/Pages/routes/setting/ServerSettingPage.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../../Components/Button.dart';
import '../../pojo/User.dart';
import '../../service/ProductService.dart';
import '../../service/UserService.dart';
// import 'package:flutter_course_design/service/lib/Request.dart';
// import 'package:http/http.dart';
// import 'package:dio/dio.dart';

// 此页面为测试页，测试所有前端代码
// 如果需要测试逻辑代码，可以使用test目录下的weight_test.dart

class TestPageBuild extends State<TestPage> {
  bool flag = false;
  String? text;
  // TextEditingController _controller = TextEditingController(
  //
  // );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: 'Test Page'),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 300,),
          buildButton(
            context,
            // child: Text("111"),
            "111",
            () async {
              // getProduct();
              // Navigator.push(
              //   context,
              //   // MaterialPageRoute(builder: (context)=>const LoginPage()),
              //   MaterialPageRoute(builder: (context) => ThemeSettingPage())
              // );
              try {
                var temp = await getAllProductInfo();
                print(temp);
                print(temp.runtimeType);
              } catch (e) {
                print(e);
              }
            },
          ),
          // TextField(
          //   controller: _controller,
          // )
        ]),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestPageBuild();
  }
}
