import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/ActionsForBlocks.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ShortText extends ExpandedStatefulWidget {
  ShortText({Key? key, this.values, required this.action, this.inDropzone = false}) : super(key: key);

  final TextEditingController _field = TextEditingController();

  @override
  String idBlock = "bref_desc";
  @override
  BlockType type = BlockType.MAP;

  @override
  Map<String, dynamic>? values;
  final ValueNotifier<ActionParam> action;

  @override
  String uuid = Uuid().v1();

  bool inDropzone;

  @override
  State<ShortText> createState() => _ShortTextState();
  
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{"text":""};
    values!['text'] = _field.text;
    return values!;
  }

  @override
  List toArrayJson() {
    return [];
  }
}

class _ShortTextState extends State<ShortText> with AutomaticKeepAliveClientMixin {

  int _charCounter = 0;
  
  @override
  void initState() {
    super.initState();
    try{
      widget._field.text = widget.values!["text"];
      setState(() {
        _charCounter = widget._field.text.length;
      });
    }catch(e){}
    
    widget._field.addListener(() { 
      _charCounter = widget._field.text.length;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(
              children: [
                Expanded(
                  child: Text("Краткий текстовый блок",style: containerLabel,)
                ), 
                if(widget.inDropzone) Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(onPressed: (){
                        widget.action.value = ActionParam(id: widget.uuid, action: BlockAction.UP);
                      }, child: Icon(Icons.arrow_upward, color: Colors.green.shade500,)),
                      OutlinedButton(onPressed: (){
                        widget.action.value = ActionParam(id: widget.uuid, action: BlockAction.DOWN);
                      }, child: Icon(Icons.arrow_downward, color: Colors.red.shade500,)),
                      OutlinedButton(onPressed: (){
                        widget.action.value = ActionParam(id: widget.uuid, action: BlockAction.DELETE);
                      }, child: Icon(Icons.delete, color: Colors.red.shade500,)),
                    ],
                  )
                )
              ]
            ),
            const Divider(height: 20,),
            TextField(
              maxLines: 10,
              controller: widget._field,
              decoration: InputDecoration(
                labelText: "Текст",
                hintText: "Текст",
                focusColor: Theme.of(context).colorScheme.primary,
                hoverColor: Theme.of(context).colorScheme.primary,
                border: const OutlineInputBorder(),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("$_charCounter"),
          )
          ],
        ),
      );
    
  }
  
  @override
  bool get wantKeepAlive => true;
}