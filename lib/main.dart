import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/AppBottomNavigationBar.dart';
import 'package:flutter_course_design/Pages/routes/order/NewOrderPage.dart';
// import 'package:flutter_course_design/Pages/home/MainPage.dart';
// import 'package:flutter_course_design/Pages/test/TestPage.dart';
import 'package:flutter_course_design/Theme/ThemeData.dart';
import 'package:flutter_course_design/service/lib/Request.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import 'Pages/HomePages.dart';
import 'Pages/test/TestPage.dart';
import 'Theme/AppProvider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
  // request.initBaseUrl();
}

class MyApp extends StatelessWidget{
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppThemeSetting();
  }

}

// 此类进行应用程序初始化设置和框架设置
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cur = 0;

  String _colorKey = 'blue';

  // 应用程序初始化区域
  @override
  void initState() {
    super.initState();
    _initAsync();
    request.initBaseUrl();
  }

  Future<void> _initAsync() async {
    await SpUtil.getInstance();
    _colorKey = SpUtil.getString('key_theme_color', defValue: 'blue')!;
    bool isDarkMode = SpUtil.getBool('theme', defValue: false)!;
    // ignore: use_build_context_synchronously
    Provider.of<AppInfoProvider>(context, listen: false).setTheme(_colorKey);
    // ignore: use_build_context_synchronously
    Provider.of<AppInfoProvider>(context, listen: false)
        .toggleTheme(isDarkMode);
  }

  void _incrementCounter() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()));
    setState(() {
      // _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[cur],

      bottomNavigationBar: DefaultBottomNavigationBar(
        context: context,
        cur: cur,
        onPress: (index) {
          if (index != cur) {
            setState(() {
              cur = index;
            });
          }
        },
      ),
    );
  }
}
