

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/BackButton.dart';
import 'package:flutter_course_design/Pages/routes/about/AboutPage.dart';
import 'package:flutter_course_design/Pages/routes/order/OrderHistory.dart';
import 'package:flutter_course_design/Pages/test/TestPage.dart';
import 'package:flutter_course_design/Theme/AppProvider.dart';

import 'package:provider/provider.dart';


// 两个通用AppBar


class DefaultThemeAppBar extends AppBar {
  final BuildContext context;
  DefaultThemeAppBar({
    Key? key,
    String? title,
    required this.context,
    super.actions,
    super.leading,
    super.leadingWidth,
    super.automaticallyImplyLeading,
  }) : super(
    key: key,
    centerTitle: true,
    title: _buildTitleWidget(title),
    backgroundColor: themeColorMap[Provider.of<AppInfoProvider>(context).themeColor],
    // 设置其他AppBar属性
    // 如：leading、actions等
  );

  static Widget _buildTitleWidget(String? title) {
    return Consumer<AppInfoProvider>(
      builder: (context, appInfo, _) {
        return Text(
          title ?? '',
          style: const TextStyle(
            // color: , // 使用全局主题数据设置文本颜色
          ),
        );
      },
    );
  }
}



class DefaultAppBar extends DefaultThemeAppBar{
  DefaultAppBar({super.key, required super.context, super.title}) : super(
    actions: [
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'about') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())); // 导航到关于页
          }else if(value == 'orderHistory'){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryPage()));
          }
          // else if(value == 'test'){
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()));
          // }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: 'orderHistory',
            child: Text('历史订单'),
          ),
          const PopupMenuItem(
            value: 'about',
            child: Text('关于'),
          ),
          // const PopupMenuItem(
          //   value: 'test',
          //   child: Text('test'),
          // ),
        ],
      ),
    ]
  );
}


class DefaultRouteAppBar extends DefaultThemeAppBar{
  DefaultRouteAppBar({super.key, required super.context, required super.title, super.actions}):super(
    leading: buildBackButton(context),
    leadingWidth: 90,
    automaticallyImplyLeading: false
  );
}


