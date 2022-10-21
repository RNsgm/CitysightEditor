import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';

class Sources extends ExpandedStatefulWidget {
  Sources({Key? key, this.values}) : super(key: key);

  final TextEditingController _field = TextEditingController();

  @override
  String idBlock = "sources";
  @override
  BlockType type = BlockType.MAP;

  @override
  Map<String, dynamic>? values;

  @override
  State<Sources> createState() => _SourcesState();
  
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

class _SourcesState extends State<Sources> with AutomaticKeepAliveClientMixin {

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
            Text("Источники",style: containerLabel,),
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