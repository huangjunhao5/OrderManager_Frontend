import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/HomePages.dart';
import '../Theme/AppProvider.dart';



class DefaultBottomNavigationBar extends BottomNavigationBar{
  final int cur;
  final void Function(int)? onPress;
  final BuildContext context;
  DefaultBottomNavigationBar({super.key, required this.cur, this.onPress, required this.context}) :super(
    items: buttonItem,
    currentIndex: cur,
    onTap: onPress,
    backgroundColor: Provider.of<AppInfoProvider>(context).isDarkMode
      ? const Color(0xFF1D2025)
      : Colors.white,
    selectedItemColor:
      Provider.of<AppInfoProvider>(context).isDarkMode ?
        Colors.lightBlueAccent  // const Color.fromARGB(255, 33, 192, 231)
        : themeColorMap[Provider.of<AppInfoProvider>(context).themeColor],
  );
}
