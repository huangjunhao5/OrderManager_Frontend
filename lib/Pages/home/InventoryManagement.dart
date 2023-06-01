import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/Pages/routes/Inventory/InventoryDetailsPage.dart';
import 'package:flutter_course_design/service/ProductService.dart';

import '../routes/Inventory/AddInventoryPage.dart';
import '../test/TestPage.dart';

class InventoryManagementPage extends StatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryManagementPageState createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  List<dynamic> inventoryList = [
    // {"id": 6, "code": "YZ", "name": "椅子", "num": 9961},
    // {"id": 7, "code": "XYZ", "name": "小椅子", "num": 9996},
    // {"id": 8, "code": "DYZ", "name": "大椅子", "num": 19988},
  ];

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future _initState() async {
    inventoryList = await getAllProductInfo();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "库存管理",
        context: context,
      ),
      body: ListView.builder(
        itemCount: inventoryList.length,
        itemBuilder: (context, index) {
          return ListItem(
            onPress: () async {
              // 跳转到商品详情页
              // TODO: 实现跳转功能
              // InventoryDetailsPage()
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InventoryDetailsPage(
                            productDetails: inventoryList[index],
                          )));
              await _initState();
            },
            title: "${inventoryList[index]['name']}",
            subTitle: "库存数量: ${inventoryList[index]['num']}",
            // trailing: PopupMenuButton(
            //   itemBuilder: (context) => [
            //     // PopupMenuItem(
            //     //   child: const Text("查看"),
            //     //   onTap: () async {
            //     //     // 跳转到商品详情页
            //     //     // TODO: 实现跳转功能
            //     //     // InventoryDetailsPage()
            //     //     print('查看商品');
            //     //     Navigator.pop(context);
            //     //     await Navigator.push(
            //     //         context,
            //     //         MaterialPageRoute(
            //     //             builder: (context) => InventoryDetailsPage(
            //     //               productDetails: inventoryList[index],
            //     //             )));
            //     //     await _initState();
            //     //   },
            //     // ),
            //     PopupMenuItem(
            //       child: const Text("删除"),
            //       onTap: () {
            //         // 删除商品
            //         // TODO: 实现删除功能
            //         print('删除商品');
            //       },
            //     ),
            //   ],
            // ),
          );
        },
      ),
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

  void _incrementCounter() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddInventoryPage()));
    await _initState();
  }
}
