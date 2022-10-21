import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/ActionsForBlocks.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Contacts extends ExpandedStatefulWidget {
  Contacts({Key? key, this.values, this.action, this.inDropzone = false}) : super(key: key);

  TextEditingController _address = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _url = TextEditingController();
  
  @override
  String idBlock = "contact";
  @override
  BlockType type = BlockType.MAP;
  final ValueNotifier<ActionParam>? action;

  @override
  String uuid = Uuid().v1();

  bool inDropzone;

  @override
  Map<String, dynamic>? values;

  @override
  State<Contacts> createState() => _ContactsState();
  
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{"address":"","phone":"","url":""};
    values!['address'] = _address.text;
    values!['phone'] = _phone.text;
    values!['url'] = _url.text;

    return values!;
  }

  @override
  List toArrayJson() {
    return [];
  }
}

class _ContactsState extends State<Contacts> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();

    try{
      widget._address.text = widget.values!['address'];
      widget._phone.text = widget.values!['phone'];
      widget._url.text = widget.values!['url'];
      
    }catch(e){
      print(e);
    }
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
                  child: Text("Контактная информация",style: containerLabel,)
                ), 
                if(widget.inDropzone) Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(onPressed: (){
                        widget.action!.value = ActionParam(id: widget.uuid, action: BlockAction.UP);
                      }, child: Icon(Icons.arrow_upward, color: Colors.green.shade500,)),
                      OutlinedButton(onPressed: (){
                        widget.action!.value = ActionParam(id: widget.uuid, action: BlockAction.DOWN);
                      }, child: Icon(Icons.arrow_downward, color: Colors.red.shade500,)),
                      OutlinedButton(onPressed: (){
                        widget.action!.value = ActionParam(id: widget.uuid, action: BlockAction.DELETE);
                      }, child: Icon(Icons.delete, color: Colors.red.shade500,)),
                    ],
                  )
                )
              ]
            ),
            const Divider(height: 20,),
            TextField(
              controller: widget._address,
              decoration: InputDecoration(
                labelText: "Адрес",
                hintText: "Адрес",
                focusColor: Theme.of(context).colorScheme.primary,
                hoverColor: Theme.of(context).colorScheme.primary,
                border: const OutlineInputBorder(),
              ),
            ),
            const Divider(height: 10, color: Colors.transparent,),
            TextField(
                controller: widget._phone,
                decoration: InputDecoration(
                  labelText: "Телефон",
                  hintText: "Телефон",
                  focusColor: Theme.of(context).colorScheme.primary,
                  hoverColor: Theme.of(context).colorScheme.primary,
                  border: const OutlineInputBorder(),
                ),
              ),
              const Divider(height: 10, color: Colors.transparent,),
              TextField(
                controller: widget._url,
                decoration: InputDecoration(
                  labelText: "Сайт",
                  hintText: "Сайт",
                  focusColor: Theme.of(context).colorScheme.primary,
                  hoverColor: Theme.of(context).colorScheme.primary,
                  border: const OutlineInputBorder(),
                ),
              ),
              const Divider(height: 10, color: Colors.transparent,),
           
          ],
        ),
      );
  }
  
  @override
  bool get wantKeepAlive => true;
}