import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Pages/home/OrderPage/OrderPageCommom.dart';

import '../../../Components/Dialog.dart';
import '../../../Exception/HttpException/PermissionDeniedException.dart';
import '../../../service/OrderService.dart';
import '../../../service/UserService.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

class OrderHistoryPageBuild extends State<OrderHistoryPage> {
  bool isLoaded = false;

  int? userType;

  List? orderList;

  Future _initState() async {
    try {
      userType = await request.getInt('type');
      orderList = await getAllOrderInfo();
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
        await PromptDialogFactory.create(context, '错误', ConnectionError);
      }
    }
    isLoaded = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: '历史订单',
      ),
      body: OrderPageCommon(
        isLoaded: isLoaded,
        userType: userType,
        orderList: orderList,
      ),
    );
  }
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State createState() {
    return OrderHistoryPageBuild();
  }
}
