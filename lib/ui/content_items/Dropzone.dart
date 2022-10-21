import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';

class Dropzone extends ExpandedStatefulWidget {
  Dropzone({Key? key, this.values, required this.children}) : super(key: key);

  static _DropzoneState? of(BuildContext context) => context.findAncestorStateOfType<_DropzoneState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _image = TextEditingController();
  
  @override
  String idBlock = "dropzone";
  @override
  BlockType type = BlockType.ARRAY;

  @override
  Map<String, dynamic>? values;
  List<ExpandedStatefulWidget> children = [];

  @override
  State<Dropzone> createState() => _DropzoneState();
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{};
    children.forEach((element) {
      if(element.type == BlockType.MAP){
        values![element.idBlock] = element.toJson();
      }else if(element.type == BlockType.ARRAY){
        values![element.idBlock] = element.toArrayJson();
      }
    });
    return values!;
  }

  @override
  List toArrayJson() {
    List<dynamic> toList = [];
    children.forEach((element) { 
      if(element.type == BlockType.MAP){
        toList.add(<String, dynamic>{element.idBlock: element.toJson()}); 
      }else if(element.type == BlockType.ARRAY){
        toList.add(<String, dynamic>{element.idBlock: element.toArrayJson()}); 
      }
    });
    return toList;
  }
}

class _DropzoneState extends State<Dropzone> with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    return Column(children: widget.children,);
  }
  
  @override
  bool get wantKeepAlive => true;
}