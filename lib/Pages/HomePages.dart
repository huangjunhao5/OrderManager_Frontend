
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Pages/home/InventoryManagement.dart';
import 'package:flutter_course_design/Pages/home/OrderPage.dart';
import 'package:flutter_course_design/Pages/home/SettingPage.dart';
import 'package:flutter_course_design/pojo/Order.dart';

import 'test/TestPage.dart';
import 'home/MainPage.dart';

// 在这里管理所有主页面


// 主页对象
var pages = [
  OrderPage(flag: OrderInfo.CreatedFlag, title: "实时订单",),
  InventoryManagementPage(),
  const SettingPage(),
];

// 底部导航栏对应的图标与文字
var buttonItem = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "订单",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.inventory),
    label: "库存",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: "设置",
  ),
];
