import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/Pages/home/SettingPageState/Logged.dart';
import 'package:flutter_course_design/Pages/home/SettingPageState/Unlogged.dart';
import 'package:flutter_course_design/Pages/routes/setting/ServerSettingPage.dart';
import 'package:flutter_course_design/Pages/routes/setting/ThemeSetting.dart';

import 'package:flutter_course_design/service/lib/Request.dart';

import '../../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingPageBuild();
  }
}

class _SettingPageBuild extends State<StatefulWidget> with RouteAware {
  bool isLogin = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 添加监听订阅
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    // 移除监听订阅
    MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  void didPopNext() {
    // print(4);
    _initState();
  }

  @override
  void initState() {
    super.initState();
    _initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }


  Future _initState() async {
    String? token = await request.getToken();
    // print(token);
    if(token != null){
      isLogin = true;
      setState(() {

      });
    }
  }
  void setLoginFlag(bool flag){
    // print(flag);
    if(flag != isLogin){
      setState(() {
        isLogin = flag;
      });
    }
  }

  // isLogin 状态选择器
  Widget settingComponents(BuildContext context){
    print("isLogin:$isLogin");
    if(isLogin){
      return LoggedComponents(context: context, setLoginFlag: setLoginFlag,);
    }else{
      return UnLoggedComponents(context: context, setLoginFlag: setLoginFlag,);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultAppBar(
        title: "设置",
        context: context,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListItem(
            onPress: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ThemeSettingPage()));
            },
            title: "主题",
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          ListItem(
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ServerSettingPage()));
              },
              title: "远程服务器设置"),
          settingComponents(context),
        ],
      ),
    );
  }
}

