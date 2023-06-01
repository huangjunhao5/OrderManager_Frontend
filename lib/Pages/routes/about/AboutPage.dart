import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        title: '关于',
        context: context,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // CircleAvatar(
            //   radius: 60.0,
            //   backgroundImage: AssetImage('assets/avatar.png'),
            // ),
            SizedBox(height: 16.0),
            Text(
              '记账本',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '版本号：1.0.0',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '作者：数字媒体技术211 黄俊豪',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            Text(
              '学号：1203002072',
              style: TextStyle(fontSize: 16.0),
              // textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              '联系我们：',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '邮箱：1814155869@qq.com',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'GitHub：huangjunhao5',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),)
      ),
    );
  }
}
