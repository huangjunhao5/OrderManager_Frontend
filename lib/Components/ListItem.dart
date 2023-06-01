

import 'package:flutter/material.dart';

class ListItem extends Container {
  final Widget? leading;
  final Widget? trailing;
  final void Function() onPress;
  final String title;
  final String? subTitle;
  // final bool diver = true;
  ListItem({super.key,required this.onPress, this.leading, required this.title,this.trailing, this.subTitle}) :
      super(
        child: Column(
          children: [
            ListTile(
              leading: leading ?? const SizedBox(width: 5,),
              onTap: onPress,
              title: Text(title),
              subtitle: subTitle == null ? null : Text(subTitle),
              trailing: trailing,
            ),
            const Divider(height: 1,)
          ],
        )
      );
}