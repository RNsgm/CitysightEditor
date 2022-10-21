import 'package:citysight_editor/enums/BlockType.dart';
import 'package:flutter/material.dart';

abstract class ExpandedStatefulWidget<T> extends StatefulWidget {  

  String uuid = "";
  String get idBlock => "";
  BlockType get type => BlockType.NONE;

  Map<String, dynamic>? values = <String, dynamic>{};

  Map<String, dynamic> toJson();
  List<dynamic> toArrayJson();

  ExpandedStatefulWidget({Key? key}) : super(key: key);
}