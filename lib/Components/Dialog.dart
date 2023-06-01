import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoadingDialog {
  static Future<void> showLoadingDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false, // 点击弹窗外部不会关闭弹窗
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(), // 加载指示器
              const SizedBox(width: 16),
              Text(message), // 加载提示文本
            ],
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

// 提示对话框封装
class PromptDialogFactory {
  static Future create(BuildContext context, String title, String text) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

// 确认对话框封装
class ConfirmDialogFactory {
  static Future create(
      BuildContext context, String title, String text, void Function() okEvent,
      {void Function()? cancerEvent}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () async {
                okEvent();
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                cancerEvent ??= () {};
                cancerEvent!();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
