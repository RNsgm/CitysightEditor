import 'dart:io';
import 'dart:typed_data';

import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/ImageEditor.dart';
import 'package:citysight_editor/utils/ShowImage.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MainBox extends ExpandedStatefulWidget {
  MainBox({Key? key, this.values}) : super(key: key);

  final TextEditingController _title = TextEditingController();
  final TextEditingController _image = TextEditingController();
  
  @override
  String idBlock = "main_box";
  @override
  BlockType type = BlockType.MAP;
  
  final RegExp _exp = RegExp(r"([a-z0-9-]+)");

  @override
  Map<String, dynamic>? values;

  @override
  State<MainBox> createState() => _MainBoxState();
  
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{"title":"","image":""};
    values!['title'] = _title.text;
    values!['image'] = _exp.stringMatch(_image.text.split(" ").last);

    return values!;
  }

  @override
  List toArrayJson() {
    return [];
  }
}

class _MainBoxState extends State<MainBox> with AutomaticKeepAliveClientMixin {

  void setImageNameInField(String name){
    getImageName(name).then(
      (value) => {

        setState(() {
          widget._image.text = "${value.name} (${value.id})";
        },)
      
      });
  }

  @override
  void initState() {
    super.initState();

    try{
      widget._title.text = widget.values!['title'];
      setImageNameInField(widget.values!['image']);
      
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
            Text("Главная",style: containerLabel,),
            const Divider(height: 20,),
            TextField(
              controller: widget._title,
              decoration: InputDecoration(
                labelText: "Заголовок",
                hintText: "Заголовок",
                focusColor: Theme.of(context).colorScheme.primary,
                hoverColor: Theme.of(context).colorScheme.primary,
                border: const OutlineInputBorder(),
              ),
            ),
            const Divider(height: 10, color: Colors.transparent,),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    readOnly: true,
                    controller: widget._image,
                    decoration: InputDecoration(
                      labelText: "Изображение",
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image.text) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image.text.split(" ").last)}.s.jpg");} : null, child: const Text("1x1")),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image.text) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image.text.split(" ").last)}.r.jpg");} : null, child: const Text("4x7")),
                OutlinedButton(onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                  );
                  if (result != null && result.files.isNotEmpty) {
                    Uint8List fileBytes = result.files.first.bytes!;
                    // File file = File.fromRawPath(fileBytes);
                    await ImageEditor.crop(context, widget._image, fileBytes);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                }, child: const Icon(Icons.upload)),
              ],
            )
          ],
        ),
      );
  }
  
  @override
  bool get wantKeepAlive => true;
}