import 'package:flutter/material.dart';
import 'package:flutter_course_design/Components/DefaultAppBar.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../../Theme/AppProvider.dart';
// import '../../../Theme/ThemeData.dart';
// import '../../../pojo/Item.dart';

class ThemeSettingPage extends StatefulWidget {
  // final bool isDarkModeEnabled; // 从上一个页面获取的主题信息

  const ThemeSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ThemeSettingPageState();
  }
}

class _ThemeSettingPageState extends State<ThemeSettingPage> {
  String _colorKey = "";

  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = Provider.of<AppInfoProvider>(context, listen: false).isDarkMode;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultRouteAppBar(
        title: "主题切换",
        context: context,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: kToolbarHeight),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 40,),
                ExpansionTile(
                  leading: const Icon(Icons.toggle_on),
                  title: const Text('切换主题'),
                  initiallyExpanded: false,
                  textColor: Colors.lightBlueAccent,
                  iconColor: Colors.lightBlueAccent,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ListTile(
                            leading: !isDarkMode ? const Icon(Icons.check) : const SizedBox(width: 10,),
                            title: const Text("浅色主题"),
                            onTap: (){
                              isDarkMode = false;
                              SpUtil.putBool('theme', isDarkMode);
                              setState(() {
                                Provider.of<AppInfoProvider>(context, listen: false).toggleTheme(isDarkMode);
                              });
                            },
                          ),
                          ListTile(
                            leading: isDarkMode ? const Icon(Icons.check) : const SizedBox(width: 10,),
                            title: const Text("深色主题"),
                            onTap: (){
                              isDarkMode = true;
                              SpUtil.putBool('theme', isDarkMode);
                              setState(() {
                                Provider.of<AppInfoProvider>(context, listen: false).toggleTheme(isDarkMode);
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                ExpansionTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('主题颜色'),
                  initiallyExpanded: false,
                  textColor: Colors.lightBlueAccent,
                  iconColor: Colors.lightBlueAccent,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: themeColorMap.keys.map((key) {
                          Color? value = themeColorMap[key];
                          return InkWell(
                            onTap: () {
                              print(key);
                              setState(() {
                                _colorKey = key;
                              });
                              SpUtil.putString('key_theme_color', key);
                              Provider.of<AppInfoProvider>(context, listen: false)
                                  .setTheme(key);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              color: value,
                              child: _colorKey == key
                                  ? const Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
