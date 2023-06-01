import 'package:flutter/material.dart';

import '../../../Components/Dialog.dart';
import '../../../Components/ListItem.dart';
import '../../../Exception/HttpException/PermissionDeniedException.dart';
import '../../../service/OrderService.dart';
import '../../../service/UserService.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../../routes/order/OrderInfo.dart';

class OrderPageCommonBuild extends State<OrderPageCommon> {
  // List? orderList;
  Widget setPage(List? orderList, int? userType, bool isLoaded) {
    if (!isLoaded) return const Text("");
    return userType == null
        ? const Center(
            child: Text(
            "请登录后查看",
            style: TextStyle(fontSize: 20),
          ))
        : ListView.builder(
            itemCount: orderList != null ? orderList.length : 0,
            itemBuilder: (context, index) {
              return Column(children: [
                const SizedBox(
                  height: 10,
                ),
                ListItem(
                    onPress: () async {
                      //跳转到订单详情页
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderInfoPage(orderInfo: orderList![index])));
                      print("跳转到订单详情页");
                      setState(() {});
                    },
                    title:
                        "订单${orderList != null ? orderList[index]['id'].toString() : ''}       "
                        "客户：${orderList != null ? orderList[index]['customer'] : ''}",
                    subTitle:
                        "创建时间：${orderList != null ? orderList[index]['createTime'] : ''}\n",
                    trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text("处理"),
                                onTap: () async {
                                  // 将订单移到已处理状态
                                  await doOrder(widget.orderList![index]['id']);
                                  print("已处理");
                                  setState(() {});
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("删除"),
                                onTap: () async {
                                  // 将订单移到已处理状态
                                  await cancerOrder(
                                      widget.orderList![index]['id']);
                                  print("已取消");
                                  setState(() {});
                                },
                              )
                            ]))
              ]);
            });
  }

  @override
  Widget build(BuildContext context) {
    return setPage(widget.orderList, widget.userType, widget.isLoaded);
  }
}

class OrderPageCommon extends StatefulWidget {
  List? orderList;
  bool isLoaded;
  int? userType;
  OrderPageCommon(
      {super.key,
      required this.isLoaded,
      required this.userType,
      this.orderList});

  @override
  State createState() {
    return OrderPageCommonBuild();
  }
}
