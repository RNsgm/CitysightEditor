import 'dart:typed_data';
import 'dart:ui';

import 'package:citysight_editor/ui/Body.dart';
import 'package:flutter/material.dart';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class HomeFragment extends StatefulWidget {
  HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {

  final GlobalKey _cropperKey2 = GlobalKey(debugLabel: 'cropperKey');
  final GlobalKey _cropperKey7 = GlobalKey(debugLabel: 'cropperKey');
  final GlobalKey _cropperKey8 = GlobalKey(debugLabel: 'cropperKey');
  final GlobalKey _cropperKey12 = GlobalKey(debugLabel: 'cropperKey');
  final GlobalKey _cropperKey13 = GlobalKey(debugLabel: 'cropperKey');
  Uint8List? image;

  Widget build(BuildContext context) {
    return Body(
      widget: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Container(
          child: const Center(
            child: Text("In Development")
          ),
        )
      ),
    );
  }
}