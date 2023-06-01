import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/Button.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/service/InventoryService.dart';

import 'package:flutter_course_design/service/lib/Request.dart';

class EditInventoryQuantityPage extends StatefulWidget {
  final Map<String, dynamic> productDetails;

  const EditInventoryQuantityPage({Key? key, required this.productDetails})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditInventoryQuantityPageState createState() =>
      _EditInventoryQuantityPageState();
}

class _EditInventoryQuantityPageState extends State<EditInventoryQuantityPage> {
  final TextEditingController _quantityController = TextEditingController();
  String _selectedAction = "增加"; // 默认选择增加

  @override
  void initState() {
    super.initState();
    _quantityController.text = "0"; // 默认库存变化为0
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        context: context,
        title: '修改库存数量',
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(width: 1.0, color: Colors.grey),
                  columnWidths: const {
                    0: FlexColumnWidth(0.3),
                    1: FlexColumnWidth(0.7),
                  },
                  children: [
                    _buildTableRow('商品编号', widget.productDetails['code']),
                    _buildTableRow('商品名称', widget.productDetails['name']),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: _selectedAction,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAction = newValue!;
                        });
                      },
                      items: <String>['增加', '减少']
                          .map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '库存变化',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                buildButton(context, '保存', () async {
                  // 获取库存变化数值
                  int quantityChange = int.parse(_quantityController.text);
                  int changeFlag = InventoryFlags.add;
                  if (_selectedAction == '减少') {
                    // quantityChange = -quantityChange; // 若选择减少，则变化数值为负数
                    changeFlag = InventoryFlags.sub;
                  }

                  // 更新库存数量
                  int currentQuantity = widget.productDetails['num'];
                  int num = quantityChange;
                  // TODO: 调用后端API，将newQuantity保存
                  try{
                    print('保存');
                    bool flag = await changeStoreNum(widget.productDetails['id'], num, changeFlag);
                    if(flag == true){
                      if(mounted)await PromptDialogFactory.create(context, '提示', '修改成功');
                      if(mounted)Navigator.pop(context);
                    }
                  }catch(e){
                    if(e is PermissionDeniedException){
                      // 权限不足或者登录过期
                      if(mounted)await PromptDialogFactory.create(context, '错误', PermissionDenied);
                    }else if(e is ConnectErrorException){
                      // 服务器异常或者连接失败
                      if(mounted)await PromptDialogFactory.create(context, '错误', ConnectionError);
                    }else{
                      print(e);
                      await PromptDialogFactory.create(context, '错误', '服务器错误，请检查输入是否合法');
                    }
                  }
                  // 返回上一页并传递更新后的库存数量
                }),
              ],
            ),
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
