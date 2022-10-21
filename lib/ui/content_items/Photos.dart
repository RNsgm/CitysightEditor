import 'dart:typed_data';

import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/ActionsForBlocks.dart';
import 'package:citysight_editor/utils/ImageEditor.dart';
import 'package:citysight_editor/utils/ShowImage.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Photos extends ExpandedStatefulWidget {
  Photos({Key? key, this.values, required this.action, this.inDropzone = false}) : super(key: key);

  final TextEditingController _image_1 = TextEditingController();
  final TextEditingController _image_2 = TextEditingController();
  final TextEditingController _image_3 = TextEditingController();
  final TextEditingController _image_4 = TextEditingController();
  final TextEditingController _image_5 = TextEditingController();
  
  @override
  String idBlock = "photos";
  @override
  BlockType type = BlockType.ARRAY;

  @override
  Map<String, dynamic>? values;
  final ValueNotifier<ActionParam> action;

  @override
  String uuid = Uuid().v1();

  bool inDropzone;

  final RegExp _exp = RegExp(r"([a-z0-9-]+)");

  @override
  State<Photos> createState() => _PhotosState();
  
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{};

    return values!;
  }

  @override
  List<String> toArrayJson() {
    List<String> imagesIds = [
      _exp.stringMatch(_image_1.text.split(" ").last) ?? "",
      _exp.stringMatch(_image_2.text.split(" ").last) ?? "",
      _exp.stringMatch(_image_3.text.split(" ").last) ?? "",
      _exp.stringMatch(_image_4.text.split(" ").last) ?? "",
      _exp.stringMatch(_image_5.text.split(" ").last) ?? "",
    ];
    return imagesIds;
  }
}

class _PhotosState extends State<Photos> with AutomaticKeepAliveClientMixin {

  List<String> arrayValues = [];

  void setImageNameInField(TextEditingController controller, String name){
    getImageName(name).then(
      (value) => {
        print(value.name),
        setState(() {
          if(value.name != "" || value.id != "")
            controller.text = "${value.name} (${value.id})";
        },)
      
      });
  }

  bool initial = false;
  @override
  void initState() {
    print(initial);
    if(widget.values == null) return;
    arrayValues = List<String>.from(widget.values!["array"]);
    try{
      setImageNameInField(widget._image_1, arrayValues[0]);
      setImageNameInField(widget._image_2, arrayValues[1]);
      setImageNameInField(widget._image_3, arrayValues[2]);
      setImageNameInField(widget._image_4, arrayValues[3]);
      setImageNameInField(widget._image_5, arrayValues[4]);
    }catch(e){
      print(e);
    }
    initial = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.values!["array"] = List<String>.from(widget.toArrayJson as List<String>);
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
                  child: Text("Блок фото",style: containerLabel,)
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
            Row(
              children: [
                Flexible(
                  child: TextField(
                    readOnly: true,
                    controller: widget._image_1,
                    decoration: InputDecoration(
                      labelText: "Изображение",
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_1.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_1.text.split(" ").last)}.s.jpg");} : null, child: const Text("1x1")),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_1.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_1.text.split(" ").last)}.r.jpg");} : null, child: const Text("4x7")),
                OutlinedButton(onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                  );
                  if (result != null && result.files.isNotEmpty) {
                    Uint8List fileBytes = result.files.first.bytes!;
                    await ImageEditor.crop(context, widget._image_1, fileBytes);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                }, child: const Icon(Icons.upload)),
                OutlinedButton(onPressed: () => setState(()=>widget._image_1.text=""), style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade500)), child: const Icon(Icons.delete),)
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    readOnly: true,
                    controller: widget._image_2,
                    decoration: InputDecoration(
                      labelText: "Изображение",
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_2.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_2.text.split(" ").last)}.s.jpg");} : null, child: const Text("1x1")),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_2.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_2.text.split(" ").last)}.r.jpg");} : null, child: const Text("4x7")),
                OutlinedButton(onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                  );
                  if (result != null && result.files.isNotEmpty) {
                    Uint8List fileBytes = result.files.first.bytes!;
                    await ImageEditor.crop(context, widget._image_2, fileBytes);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                }, child: const Icon(Icons.upload)),
                OutlinedButton(onPressed: () => setState(()=>widget._image_2.text=""), style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade500)), child: const Icon(Icons.delete),)
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    readOnly: true,
                    controller: widget._image_3,
                    decoration: InputDecoration(
                      labelText: "Изображение",
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_3.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_3.text.split(" ").last)}.s.jpg");} : null, child: const Text("1x1")),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_3.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_3.text.split(" ").last)}.r.jpg");} : null, child: const Text("4x7")),
                OutlinedButton(onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                  );
                  if (result != null && result.files.isNotEmpty) {
                    Uint8List fileBytes = result.files.first.bytes!;
                    await ImageEditor.crop(context, widget._image_3, fileBytes);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                }, child: const Icon(Icons.upload)),
                OutlinedButton(onPressed: () => setState(()=>widget._image_3.text=""), style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade500)), child: const Icon(Icons.delete),)
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    readOnly: true,
                    controller: widget._image_4,
                    decoration: InputDecoration(
                      labelText: "Изображение",
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_4.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_4.text.split(" ").last)}.s.jpg");} : null, child: const Text("1x1")),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_4.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_4.text.split(" ").last)}.r.jpg");} : null, child: const Text("4x7")),
                OutlinedButton(onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                  );
                  if (result != null && result.files.isNotEmpty) {
                    Uint8List fileBytes = result.files.first.bytes!;
                    await ImageEditor.crop(context, widget._image_4, fileBytes);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                }, child: const Icon(Icons.upload)),
                OutlinedButton(onPressed: () => setState(()=>widget._image_4.text=""), style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade500)), child: const Icon(Icons.delete),)
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    readOnly: true,
                    controller: widget._image_5,
                    decoration: InputDecoration(
                      labelText: "Изображение",
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_5.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_5.text.split(" ").last)}.s.jpg");} : null, child: const Text("1x1")),
                OutlinedButton(onPressed: widget._exp.stringMatch(widget._image_5.text.split(" ").last) != null ? (){ShowImage.show(context, "$baseContentUrl/img/${widget._exp.stringMatch(widget._image_5.text.split(" ").last)}.r.jpg");} : null, child: const Text("4x7")),
                OutlinedButton(onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image
                  );
                  if (result != null && result.files.isNotEmpty) {
                    Uint8List fileBytes = result.files.first.bytes!;
                    await ImageEditor.crop(context, widget._image_5, fileBytes);
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                }, child: const Icon(Icons.upload)),
                OutlinedButton(onPressed: () => setState(()=>widget._image_5.text=""), style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade500)), child: const Icon(Icons.delete),)
              ],
            ),
          ],
        ),
      );
  }
  
  @override
  bool get wantKeepAlive => true;
}