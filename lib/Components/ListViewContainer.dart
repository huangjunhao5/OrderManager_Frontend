

import 'package:flutter/material.dart';


// 自动占满剩余空间的ListView

class ListViewContainer extends Container{
  final List<Widget> children;
  ListViewContainer({super.key, required this.children}):super(
    child: Expanded(
        child: ListView(
          children: children,
        )
    )
  );
}