import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Theme/AppProvider.dart';

Widget buildButton(
    BuildContext context, String text, void Function()? buttonClicked) {
  final themeColor = themeColorMap[Provider.of<AppInfoProvider>(context).themeColor];
  return Align(
    child: SizedBox(
      height: 45,
      width: 280,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(MaterialState.pressed)) {
                // 按钮被按下时的颜色
                return themeColor?.withOpacity(0.8);
              }
              // 默认状态下的颜色
              return themeColor;
            },
          ),
            // 设置圆角
            shape: MaterialStateProperty.all(const StadiumBorder(
                side: BorderSide(style: BorderStyle.none)))),
        onPressed: buttonClicked,
        child: Text(
            text,
            // style: Theme.of(context).primaryTextTheme.bodyLarge
          style: const TextStyle(
            fontSize: 18,
            // color: ???,
          ),
        ),
      ),
    ),
  );
}
