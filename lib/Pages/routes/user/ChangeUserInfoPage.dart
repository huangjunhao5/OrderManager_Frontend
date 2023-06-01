import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/pojo/User.dart';
import 'package:flutter_course_design/service/UserService.dart';

import '../../../Exception/HttpException/PermissionDeniedException.dart';
import '../../../service/lib/Request.dart';

class ChangeUserInfoPageBuild extends State<ChangeUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultRouteAppBar(
        title: '修改用户类型',
        context: context,
        actions: [
          IconButton(
              onPressed: () async {
                try{
                  int flag = await submitUserType(widget.username, widget.type);
                  if(flag == ok){
                    if(mounted){
                      widget.getNowType?.call(widget.type);
                      await PromptDialogFactory.create(context, '修改成功', '用户类型修改成功');
                      if(mounted) {
                        Navigator.pop(context);
                      }
                    }
                  }
                }catch(e){
                  print(e);
                  if(mounted){
                    if (e is PermissionDeniedException) {
                      PromptDialogFactory.create(
                          context, '修改失败', PermissionDenied);
                    } else {
                      PromptDialogFactory.create(
                          context, '修改失败', ConnectionError);
                    }
                  }
                }
                // print('用户类型已经修改');
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: ListView(
        children: [
          ListItem(
            onPress: () {
              widget.type = User.admin;
              setState(() {});
            },
            title: '管理员',
            leading:
                (widget.type == User.admin) ? const Icon(Icons.check) : null,
          ),
          ListItem(
            onPress: () {
              widget.type = User.user;
              setState(() {});
            },
            title: '普通用户',
            leading:
                (widget.type == User.user) ? const Icon(Icons.check) : null,
          ),
        ],
      ),
    );
  }
}

class ChangeUserInfoPage extends StatefulWidget {
  ChangeUserInfoPage({super.key, required this.username, required this.type, this.getNowType});
  String username;
  int type;
  void Function(int)? getNowType = (nowType){};
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangeUserInfoPageBuild();
  }
}
