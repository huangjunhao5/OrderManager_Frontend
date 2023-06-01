import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'AppProvider.dart';

// 此类进行应用程序主题的管理
class AppThemeSetting extends StatelessWidget {
  AppThemeSetting({super.key});

  Color? _themeColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppInfoProvider>(
            create: (_) => AppInfoProvider()),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (context, appInfo, _) {
          String colorKey = appInfo.themeColor;
          if (themeColorMap[colorKey] != null) {
            _themeColor = themeColorMap[colorKey];
          }

          return MaterialApp(
              navigatorObservers: [MyApp.routeObserver],
              title: 'Flutter Demo',
              theme: appInfo.isDarkMode
                  // 深色主题设置
                  ? ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: const Color.fromARGB(255, 8, 8, 8),
                  primaryColor: _themeColor,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: _themeColor, // 设置悬浮操作按钮的背景颜色
                    // 其他悬浮操作按钮的样式属性
                  ))
                  // 浅色主题设置
                  : ThemeData.light().copyWith(
                  primaryColor: _themeColor,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: _themeColor, // 设置悬浮操作按钮的背景颜色
                    // 其他悬浮操作按钮的样式属性
                  )),
              // 将页面状态传递给主页面（应用程序框架页面）
              home: ThemeContainer(
                child: const MyHomePage(title: '1203002072 黄俊豪'),
              ));
        },
      ),
    );
  }
}


class ThemeContainer extends Consumer<AppInfoProvider>{
  final child;
  ThemeContainer({super.key,required this.child}):super(
    builder: (context, appInfo, _) {
      Color? themeColor = themeColorMap[appInfo.themeColor];

      // 在 UI 中使用主题颜色
      return Container(
        color: themeColor,
        child: child,
        // ...
      );
    }
  );
}


