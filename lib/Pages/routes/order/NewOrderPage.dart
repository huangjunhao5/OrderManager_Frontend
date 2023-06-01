// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Components/GestureDetectorContainer.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/pojo/Order.dart';
import 'package:flutter_course_design/service/OrderService.dart';
import 'package:flutter_course_design/service/ProductService.dart';

import 'package:flutter_course_design/service/lib/Request.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key}) : super(key: key);
  
  @override
  // ignore: library_private_types_in_public_api
  _NewOrderPageState createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  List<Map<String, dynamic>> products = [];
  // List<TextEditingController> controllers = [];
  List? allProducts;
  String customer = "";
  bool isLocked = false;

  int load = 0;
  static int unLoaded = 0;
  static int Loaded = 1;
  static int errLoaded = 2;
  String? getProductName(String code){
    int len = allProducts == null ? 0 :allProducts!.length;
    for(int i = 0;i < len;i ++){
      if(allProducts![i]['code'] == code){
        return allProducts![i]['name'];
      }
    }
    return null;
  }

  Future submit(BuildContext context) async {
    OrderInfo orderInfo = OrderInfo(customer);
    List<OrderList> orderLists = [];
    for (var product in products) {
      final String productId = product['productId'];
      final String productName = product['productName'];
      final int num = product['num'];
      int len = allProducts == null ? 0 :allProducts!.length;
      int id = -1;
      for(int i = 0;i < len;i ++){
        if(allProducts![i]['code'] == product['productId']){
          id = allProducts![i]['id'];
          break;
        }
      }
      if(id == -1){
        await PromptDialogFactory.create(context, '错误', '校验失败，请检查输入到数据是否合法');
        return;
      }
      OrderList orderList = OrderList(id, num);
      orderLists.add(orderList);
      // 在这里使用商品的值，可以将其打印出来或进行其他操作
      print('商品ID: $productId, 商品名称: $productName, 数量: $num');
    }
    Order order = Order(orderInfo, orderLists);
    // 将数据上传到后端
    try{
      bool flag = await createOrder(order);
      if (flag == true) {
        if (mounted) await PromptDialogFactory.create(context, '提示', '操作成功');
        if (mounted) Navigator.pop(context);
      } else {
        throw ConnectErrorException();
      }
    }catch(e){
      if(e is PermissionDeniedException){
        if(mounted)PromptDialogFactory.create(context, '错误', PermissionDenied);
      }else{
        if(mounted)PromptDialogFactory.create(context, '错误', ConnectionError);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future _initState() async {
    try{
      allProducts = await getAllProductInfo();
      print(allProducts);
      load = Loaded;
    }catch(e){
      load = errLoaded;
      print("err");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(load == unLoaded || load == errLoaded){
      return Scaffold(
        appBar: DefaultRouteAppBar(
          context: context,
          title: "新建订单",
          actions: [
            IconButton(
                onPressed: () async {
                  if(isLocked) {
                    print('locked!');
                    return;
                  }
                  isLocked = true;
                  await submit(context);
                  isLocked = false;
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: Center(
          child: Text(
            load == unLoaded ? "正在加载" : "加载失败",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: "新建订单",
        actions: [
          IconButton(
              onPressed: () async {
                if(isLocked) {
                  print('locked!');
                  return;
                }
                isLocked = true;
                await submit(context);
                isLocked = false;
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: GestureDetectorContainer(
          context: context,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: TextEditingController(text: customer),
                    onChanged: (value){
                      customer = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "客户名称",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(width: 1.0, color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(1.0),
                      1: FlexColumnWidth(2.4),
                      2: FlexColumnWidth(1.0),
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
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("操作"),
                            ),
                          ),
                        ],
                      ),
                      ...products.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final Map<String, dynamic> product = entry.value;
                        final TextEditingController idController =
                            TextEditingController(text: product['productId']);
                        final TextEditingController nameController =
                            TextEditingController(text: product['productName']);
                        final TextEditingController numController =
                            TextEditingController(
                                text: product['num'].toString());

                        return TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: idController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8.0),
                                  ),
                                  onChanged: (value) {
                                    products[index]['productId'] = value;
                                    String? productName = getProductName(value);
                                    if(productName != null && productName != products[index]['productName']){
                                      setState(() {
                                        products[index]['productName'] = productName;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8.0),
                                  ),
                                  onChanged: (value) {
                                    products[index]['productName'] = value;
                                  },
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: numController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8.0),
                                  ),
                                  onChanged: (value) {
                                    products[index]['num'] =
                                        int.tryParse(value) ?? 0;
                                  },
                                ),
                              ),
                            ),
                            TableCell(
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    products.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  buildButton(
                    context,
                    "添加商品",
                    () {
                      setState(() {
                        products.add({
                          'productId': '',
                          'productName': '',
                          'num': 0,
                        });
                      });
                    },
                  ),
                ],
              ),
            )
          ])),
    );
  }
}
