import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/pojo/Order.dart';

import '../../../service/OrderService.dart';
import '../../../service/lib/Request.dart';

class OrderInfoBuild extends State<OrderInfoPage> {
  List<dynamic> orderLists = [];

  @override
  void initState() {
    super.initState();
    print(widget.orderInfo);
    _initState();
  }

  Future<void> _initState() async {
    orderLists = await getOrder(widget.orderInfo['id']);
    if (mounted) setState(() {}); // 触发页面刷新
  }

  Future cancerOrderClicked(BuildContext context) async {
    print(widget.orderInfo);
    print('取消订单');
    try {
      await cancerOrder(widget.orderInfo['id']);
      if (mounted) await PromptDialogFactory.create(context, '提示', '处理完成');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (e is PermissionDeniedException) {
        if (mounted) {
          PromptDialogFactory.create(context, '错误', PermissionDenied);
        }
      } else {
        if (mounted) PromptDialogFactory.create(context, '错误', ConnectionError);
      }
    }
  }

  Future doOrderClicked(BuildContext context) async {
    print('处理订单');
    try{
      await doOrder(widget.orderInfo['id']);
      if (mounted) await PromptDialogFactory.create(context, '提示', '处理完成');
      if (mounted) Navigator.pop(context);
    }catch(e){
      if(e is PermissionDeniedException){
        if (mounted) await PromptDialogFactory.create(context, '错误', PermissionDenied);
      }else if(e is ConnectErrorException){
        if (mounted) await PromptDialogFactory.create(context, '错误', ConnectionError);
      }else{
        if (mounted) await PromptDialogFactory.create(context, '错误', '服务器错误，请检查数据合法性！');
      }
    }
  }

  // ignore: non_constant_identifier_names
  Widget ButtonShow(BuildContext context) {
    if (widget.orderInfo['flag'] == OrderInfo.CreatedFlag) {
      return Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          buildButton(context, '处理订单', () {doOrderClicked(context);}),
          const SizedBox(
            height: 10,
          ),
          buildButton(context, '取消订单', () {
            cancerOrderClicked(context);
          }),
        ],
      );
    } else if (widget.orderInfo['flag'] == OrderInfo.EndFlag) {
      return Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          buildButton(context, '取消订单', () {
            cancerOrderClicked(context);
          }),
        ],
      );
    } else {
      return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        title: "订单详情",
        context: context,
      ),
      body: ListView(children: [Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "订单详情",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(width: 1.0, color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(0.4),
                1: FlexColumnWidth(0.6),
              },
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("订单ID"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.orderInfo['id']}"),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("创建时间"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.orderInfo['createTime']}"),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("客户"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.orderInfo['customer']}"),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("状态"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.orderInfo['flag'] == OrderInfo.CreatedFlag
                              ? '未完成'
                              : widget.orderInfo['flag'] == OrderInfo.EndFlag
                                  ? '已完成'
                                  : '已取消',
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("价格"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.orderInfo['price'] != null
                            ? '¥${widget.orderInfo['price'].toStringAsFixed(2)}'
                            : "已取消"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 36),
            // const Text(
            //   "订单商品",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(width: 1.0, color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(0.3),
                1: FlexColumnWidth(0.4),
                2: FlexColumnWidth(0.3),
              },
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("商品ID"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("商品名称"),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("数量"),
                      ),
                    ),
                  ],
                ),
                ...orderLists.map((product) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${product['productId']}"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${product['productName']}"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${product['num']}"),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            ButtonShow(context),
          ],
        ),
      )]),
    );
  }
}

class OrderInfoPage extends StatefulWidget {
  const OrderInfoPage({Key? key, required this.orderInfo}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final orderInfo;

  @override
  State createState() => OrderInfoBuild();
}
