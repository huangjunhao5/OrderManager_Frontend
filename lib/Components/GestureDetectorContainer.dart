import 'package:flutter/cupertino.dart';

class GestureDetectorContainer extends GestureDetector {
  final child;
  BuildContext context;
  GestureDetectorContainer({super.key, required this.context, this.child})
      : super(
          child: child,
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
}
