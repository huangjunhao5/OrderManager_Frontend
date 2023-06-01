import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageState extends State<StatefulWidget> {
  String? webViewUrl;
  String? title;
  WebViewPageState(String url, String? title) : super(){
    webViewUrl = url;
    if(title == null){
      this.title = webViewUrl;
    }else{
      this.title = title;
    }
    // print(url);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: WebView(
          initialUrl: "$webViewUrl",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WebViewPage extends StatefulWidget {
  String? webViewUrl;
  String? title;

  WebViewPage(String url, String? title, {super.key}) : super(){
    webViewUrl = url;
    if(title == null){
      this.title = webViewUrl;
    }else{
      this.title = title;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    // ignore: no_logic_in_create_state
    return WebViewPageState(webViewUrl!, title);
  }
}
