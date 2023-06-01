import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/Pages/home/OrderPage/OrderPageCommom.dart';
import 'package:flutter_course_design/Pages/routes/order/NewOrderPage.dart';
import 'package:flutter_course_design/Pages/routes/order/OrderInfo.dart';
// import 'package:flutter_course_design/pojo/User.dart';
import 'package:flutter_course_design/service/OrderService.dart';
import 'package:flutter_course_design/service/UserService.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

class OrderPageBuild extends State<OrderPage> {
  List? orderList;
  int? userType;

  Timer? _timer;

  bool isLoaded = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: widget.title,
      ),
      body: OrderPageCommon(isLoaded: isLoaded, userType: userType, orderList: orderList,),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        heroTag: 'MainPage',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initState();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (userType == null) return; // 未登录直接结束函数，节约性能
      // 在这里执行定时运行的函数
      _initState();
    });
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel(); // 在页面销毁时取消计时器
    super.dispose();
  }

  Future _initState() async {
    try {
      userType = await request.getInt('type');
      orderList = await getAllCreatedOrderInfo();
      // print(orderList![0].runtimeType);
      // print(orderList);
    } catch (e) {
      if (e is PermissionDeniedException) {
        if (userType != null) {
          // 弹窗：登录已过期，请重新登录
          print('登录已过期，请重新登录');
          await PromptDialogFactory.create(context, '错误', LoginExpired);
          await logout();
          userType = null;
        }
      } else {
        // 弹窗：连接错误，请稍后重试
        print('连接错误，请稍后重试');
        if(mounted) {
          await PromptDialogFactory.create(context, '错误', ConnectionError);
        }
      }
    }
    isLoaded = true;
    if (mounted) setState(() {});
  }

  void _incrementCounter() async {
    // 新建订单
    await Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderPage()));
    await _initState();
  }
}

// ignore: must_be_immutable
class OrderPage extends StatefulWidget {
  String title = "";
  int flag = 0;
  static int now = 0;
  static int all = 1;
  @override
  State createState() {
    return OrderPageBuild();
  }

  OrderPage({super.key, this.title = "", required this.flag}) : super();
}
