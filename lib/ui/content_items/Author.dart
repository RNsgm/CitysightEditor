import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';

class Author extends ExpandedStatefulWidget {
  Author({Key? key, required this.show}) : super(key: key);

  @override
  String idBlock = "author";
  @override
  BlockType type = BlockType.MAP;

  @override
  State<Author> createState() => _AuthorState();

  final ValueNotifier<bool> show;
  
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{};

    return values!;
  }

  @override
  List toArrayJson() {
    return [];
  }
}

class _AuthorState extends State<Author> {

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.show, 
      builder: (context, child) {
        return widget.show.value ? Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12, width: 2),
            borderRadius: BorderRadius.circular(7.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Автор",style: containerLabel,),
              const Divider(height: 20,),
            ],
          ),
        ) : Container();
      }
    );
  }
}