import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';

import '../../../service/ProductService.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

class AddInventoryPage extends StatefulWidget {
  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool isLocked = false;
  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future _saveInventory(BuildContext context) async {
    String code = _codeController.text;
    String name = _nameController.text;
    int price = 0;
    try{
      price = int.parse(_priceController.text);
      if(price == 0 || code == '' || name == '')throw Exception("数据错误");
    }catch(e){
      await PromptDialogFactory.create(context, '错误', '请输入完整数据');
      return;
    }
    // 构建商品信息
    Map<String, dynamic> productDetails = {
      'code': code,
      'name': name,
      'num': 0, // 默认数量为0
      'price': price,
    };
    var data = FormData.fromMap(productDetails);
    // TODO: 将productDetails上传到后端
    print("新建商品");
    try {
      bool flag = await createNewProduct(data);
      if (flag == true) {
        if (mounted) await PromptDialogFactory.create(context, '提示', '添加成功');
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (e is PermissionDeniedException) {
        //
        await PromptDialogFactory.create(context, '错误', PermissionDenied);
      } else if (e is ConnectErrorException) {
        await PromptDialogFactory.create(context, '错误', ConnectionError);
      } else {
        await PromptDialogFactory.create(context, '错误', '服务器错误，请检查数据是否合法');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: '新建库存商品',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: '商品编号',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '商品名称',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '商品价格',
              ),
            ),
            const SizedBox(height: 32.0),
            buildButton(
              context,
              '保存',
              () async {
                if(isLocked){
                  return;
                }
                isLocked = true;
                await _saveInventory(context);
                isLocked = false;
              },
            ),
          ],
        ),
      ),
    );
  }
}
