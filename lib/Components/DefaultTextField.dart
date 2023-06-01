import 'package:flutter/material.dart';

class DefaultTextField extends TextField {
  String text;
  DefaultTextField({
    super.key,
    super.enabled,
    super.textAlign,
    super.onTap,
    super.onChanged,
    super.autocorrect,
    super.autofillHints,
    super.autofocus,
    super.buildCounter,
    super.canRequestFocus,
    super.clipBehavior,
    super.contentInsertionConfiguration,
    super.contextMenuBuilder,
    super.inputFormatters,
    super.magnifierConfiguration,
    super.maxLength,
    super.minLines,
    super.maxLines,
    super.decoration,
    super.obscureText,
    required this.text,
  }) : super(
          controller: TextEditingController(text: text),
        );
}


// iOS风格

// TextField(
// decoration: InputDecoration(
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(8.0),
// ),
// filled: true,
// fillColor: Colors.grey[200],
// hintText: 'Enter text',
// ),
// // 添加其他属性和回调函数
// ),

