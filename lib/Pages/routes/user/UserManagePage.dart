import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:flutter_course_design/Components/Dialog.dart';
import 'package:flutter_course_design/Components/GestureDetectorContainer.dart';
import 'package:flutter_course_design/Components/ListItem.dart';
import 'package:flutter_course_design/Exception/HttpException/ConnectErrorException.dart';
import 'package:flutter_course_design/Exception/HttpException/PermissionDeniedException.dart';
import 'package:flutter_course_design/Pages/routes/user/ChangePassworPage.dart';
import 'package:flutter_course_design/service/lib/Request.dart';

import '../../../pojo/User.dart';
import '../../../service/UserService.dart';
import 'UserInfo.dart';

class UserManagePageBuild extends State<UserManagePage> {
  int? userCount = 0;
  List? userList;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultRouteAppBar(
        title: "用户管理",
        context: context,
      ),
      body: GestureDetectorContainer(
        context: context,
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: userCount,
              itemBuilder: (context, index) {
                return ListItem(
                  onPress: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserInfo(
                                  username: userList?[index]['username'],
                                  userType: userList?[index]['type'],
                                )));
                  },
                  title: userList?[index]['username'],
                  trailing: (userList![index]['type'] != User.superAdmin)
                      ? IconButton(
                          onPressed: () async {
                            await ConfirmDialogFactory.create(
                                context, "提示", '确定要删除这位用户吗？', () async {
                              // print("用户删除");
                              try {
                                int flag = await deleteUser(userList?[index]['id']);
                                if(flag == err){
                                  throw ConnectErrorException();
                                }
                                // print('111');
                                if (mounted) {
                                  await PromptDialogFactory.create(
                                      context, '删除成功', '用户删除成功');
                                  // if (mounted) {
                                  //   Navigator.pop(context);
                                  // }
                                  _initState();
                                }
                              } catch (e) {
                                if (mounted) {
                                  if (e is PermissionDeniedException) {
                                    PromptDialogFactory.create(
                                        context, '删除失败', PermissionDenied);
                                  } else {
                                    PromptDialogFactory.create(
                                        context, '删除失败', ConnectionError);
                                  }
                                }
                              }
                            });
                            await _initState();
                          },
                          icon: const Icon(Icons.delete_outline))
                      : null,
                );
              }),
        ),
      ),
    );
  }

  @override
  void initState() {
    _initState();
  }

  Future _initState() async {
    userList = await ListUser();
    userCount = userList?.length;
    if (mounted) {
      setState(() {});
    }
  }
}

class UserManagePage extends StatefulWidget {
  const UserManagePage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserManagePageBuild();
  }
}
