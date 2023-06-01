import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Theme/AppProvider.dart';

Widget buildBackButton(BuildContext context, {bool isAppBar = true}) {
  return TextButton(
    child: Row(children: [
      Icon(
        Icons.arrow_back_ios_new_rounded,
        color: getColor(context, isAppBar),
      ),
      Text(
        " 返回",
        style: TextStyle(fontSize: 18, color: getColor(context, isAppBar)),
      )
    ]),
    // themeColorMap[Provider.of<AppInfoProvider>(context).themeColor],
    onPressed: () {
      // 按钮点击事件
      Navigator.pop(context);
    },
  );
}

// Icon(Icons.arrow_back),


Color? getColor(BuildContext context, bool isAppbar){
  if(!isAppbar)return Colors.blue;
  var themeColor = Provider.of<AppInfoProvider>(context).themeColor;
  return backButtonColor[themeColor];
}
