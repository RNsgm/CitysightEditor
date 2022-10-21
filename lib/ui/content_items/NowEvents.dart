import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';

class NowEvents extends ExpandedStatefulWidget {
  NowEvents({Key? key, required this.show}) : super(key: key);

  @override
  String idBlock = "now_events";
  @override
  BlockType type = BlockType.MAP;

  @override
  State<NowEvents> createState() => _NowEventsState();

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

class _NowEventsState extends State<NowEvents> {

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
              Text("Актуальные события",style: containerLabel,),
              const Divider(height: 20,),
            ],
          ),
        ) : Container();
      }
    );
  }
}