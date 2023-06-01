import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/pojo/Product.dart';
import 'package:flutter_course_design/service/ProductService.dart';

import '../../../service/lib/Request.dart';

class EditInventoryPage extends StatefulWidget {
  final Map<String, dynamic> productDetails;

  const EditInventoryPage({Key? key, required this.productDetails})
      : super(key: key);

  @override
  _EditInventoryPageState createState() => _EditInventoryPageState();
}

class _EditInventoryPageState extends State<EditInventoryPage> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 初始化文本输入框的默认值
    _codeController.text = widget.productDetails['code'];
    _nameController.text = widget.productDetails['name'];
    _numController.text = widget.productDetails['num'].toString();
    _priceController.text = widget.productDetails['price'].toString();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _numController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: '商品信息修改',
      ),
      body: ListView(
        children: [
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
                _buildEditableTableRow(
                  '\n商品编号',
                  _codeController,
                ),
                _buildEditableTableRow(
                  '\n商品名称',
                  _nameController,
                ),
                _buildEditableTableRow(
                  '\n商品价格',
                  _priceController,
                ),
                // _buildEditableTableRow(
                //   '\n库存数量',
                //   _numController,
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          buildButton(context, '保存', () async {
            // 获取修改后的商品信息
            String code = _codeController.text;
            String name = _nameController.text;
            int num = int.parse(_numController.text);
            int price = int.parse(_priceController.text);
            var product = Product(widget.productDetails['id'], code, name, price);
            print(product);

            // TODO: 调用后端API，将updatedProductDetails保存
            try{
              bool flag = await updateProduct(product);
              if(flag == true){
                // 构建更新后的商品信息
                Map<String, dynamic> updatedProductDetails = {
                  'id': widget.productDetails['id'],
                  'code': code,
                  'name': name,
                  'num': num,
                };
                if(mounted)await PromptDialogFactory.create(context, '提示', '修改成功');
                // 返回上一页
                if(mounted)Navigator.pop(context);
              }
            }catch(e){
              if(e is PermissionDeniedException){
                await PromptDialogFactory.create(context, '错误', PermissionDenied);
              }else if(e is ConnectErrorException){
                await PromptDialogFactory.create(context, '错误', ConnectionError);
              }else{
                await PromptDialogFactory.create(context, '错误', '修改失败，请检查数据是否合法');
              }
            }
          }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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

  TableRow _buildEditableTableRow(String label, TextEditingController controller) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}
