import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Pages/routes/Inventory/AddInventoryPage.dart';
import 'package:flutter_course_design/Pages/routes/Inventory/EditInventoryPage.dart';
import 'package:flutter_course_design/Pages/routes/Inventory/EditInventoryQuantityPage.dart';
import 'package:flutter_course_design/service/ProductService.dart';

class InventoryDetailsPage extends StatefulWidget {
  Map<String, dynamic> productDetails;

  InventoryDetailsPage({Key? key, required this.productDetails})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InventoryDetailsPageState createState() => _InventoryDetailsPageState();
}

class _InventoryDetailsPageState extends State<InventoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: '库存详情',
      ),
      body: ListView(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Table(
            border: TableBorder.all(width: 1.0, color: Colors.grey),
            columnWidths: const {
              0: FlexColumnWidth(0.3),
              1: FlexColumnWidth(0.7),
            },
            children: [
              _buildTableRow('商品ID', widget.productDetails['id'].toString()),
              _buildTableRow('商品编号', widget.productDetails['code']),
              _buildTableRow('商品名称', widget.productDetails['name']),
              _buildTableRow('商品价格', "¥${widget.productDetails['price']}"),
              _buildTableRow('库存数量', widget.productDetails['num'].toString()),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        buildButton(context, '修改库存', () async {
          print('修改库存数量');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditInventoryQuantityPage(
                      productDetails: widget.productDetails)));
          widget.productDetails =
              await getProductById(widget.productDetails['id']);
          setState(() {});
        }),
        const SizedBox(
          height: 20,
        ),
        buildButton(context, '修改商品信息', () async {
          print('修改商品信息');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditInventoryPage(
                      productDetails: widget.productDetails)));
          widget.productDetails =
              await getProductById(widget.productDetails['id']);
          setState(() {});
        })
      ]),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value),
          ),
        ),
      ],
    );
  }
}
