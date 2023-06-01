import 'package:flutter/material.dart';


// 主题管理器：管理所有主题相关内容，进一步封装各个组件来加载主题
class AppInfoProvider with ChangeNotifier {
  String _themeColor = '';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

  void toggleTheme(bool flag) {
    _isDarkMode = flag;
    notifyListeners();
  }
}



// 主题颜色可选范围
Map<String, Color> themeColorMap = {
  'AppleDark': const Color(0xFF1D2025),
  'black': Colors.black,
  'gray': Colors.grey,
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
  'cyan': Colors.cyan,
  'skyblue': const Color.fromARGB(255, 135, 206, 235),
  'deepPurple': Colors.purple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'deepOrange': Colors.orange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'indigoAccent': Colors.indigoAccent,
  'orange': Colors.orange,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
};


Map<String, Color> backButtonColor = {
  'AppleDark': Colors.blue,
  'black': Colors.blue,
  'gray': Colors.white,
  'blue': Colors.white,
  'blueAccent': Colors.white,
  'cyan': Colors.white,
  'skyblue': Colors.white,
  'deepPurple': Colors.white,
  'deepPurpleAccent': Colors.white,
  'deepOrange': Colors.white,
  'green': Colors.white,
  'indigo': Colors.white,
  'indigoAccent': Colors.white,
  'orange': Colors.white,
  'purple': Colors.white,
  'pink': Colors.white,
  'red': Colors.white,
  'teal': Colors.white,
};




