import 'dart:io';
import 'dart:typed_data';

import 'package:citysight_editor/dto/ContentDto.dart';
import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/enums/ContentType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/ActionsForBlocks.dart';
import 'package:citysight_editor/utils/ImageEditor.dart';
import 'package:citysight_editor/utils/ShowImage.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loadany/loadany.dart';
import 'package:uuid/uuid.dart';

class LinkToContent extends ExpandedStatefulWidget {
  LinkToContent({Key? key, this.values, required this.action, this.inDropzone = false}) : super(key: key);

  @override
  String idBlock = "content_box";
  @override
  BlockType type = BlockType.ARRAY;

  @override
  Map<String, dynamic>? values;
  final ValueNotifier<ActionParam> action;

  @override
  String uuid = Uuid().v1();

  bool inDropzone;

  @override
  State<LinkToContent> createState() => _LinkToContentState();

  final List<CheckboxContent> _contentItems = [];

  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{};

    return values!;
  }

  @override
  List toArrayJson() {
    List<int> ids = [];
    for(CheckboxContent c in _contentItems){
      if(c.isSelected()){
        ids.add(c.id);
      }
    }

    return ids;
  }
}

class _LinkToContentState extends State<LinkToContent> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollControllerContent = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Widget loaderIndicator = const Center(
    child: CircularProgressIndicator(),
  );

  LoadStatus listContentStatus = LoadStatus.normal;
  LoadStatus contentFrameStatus = LoadStatus.normal;

  int _actualPage = 0;

  Future<void> loadMore() async {
    setState(() {
      listContentStatus = LoadStatus.loading;
    });
    try {
      List<ContentDto> contents = [];

      if (_searchController.text != "") {
        contents.addAll(await getContentByQuery(_actualPage, _searchController.text));
        listContentStatus = LoadStatus.completed;

        for(int i = 0; i < contents.length; i++){
          final index = widget._contentItems.indexWhere((element) => element.id == contents[i].id);
          logger.d("Title: ${contents[i].title} id: ${contents[i].id} EqualsIndex: $index");
          if(index == -1) {
            widget._contentItems.add(CheckboxContent.build(contents[i].id, contents[i], true));
          }
        }
      } else {

        listContentStatus = LoadStatus.completed;
      }
      listContentStatus = LoadStatus.normal;
      _actualPage += 1;
      setState(() {});
    } catch (e) {
      listContentStatus = LoadStatus.error;
    }
  }

  void fillStartLinkToContent() async {
    for(var id in widget.values!['array']){
      ContentDto? content = await getContentByID(int.parse(id));
      logger.wtf(content!.title);
      if(content != null){
        var checked = CheckboxContent.build(content.id, content, true);
        checked.selected = true;
        setState(() {
          widget._contentItems.add(checked);
        });
      }
    }
  }

  Widget getIcon(ContentType type){
    switch(type){
      case ContentType.ARTICLE:
        return Icon(Icons.article, color: Colors.blue.shade500);
      case ContentType.ROUTE:
        return Icon(Icons.route, color: Colors.lightGreen.shade500);
      case ContentType.EVENT:
        return Icon(Icons.event, color: Colors.orange.shade500);
      case ContentType.PLACE:
        return Icon(Icons.place, color: Colors.red.shade500);
      case ContentType.ORGANIZATION:
        return Icon(Icons.business, color: Colors.purple.shade500);
      default:
        return Icon(Icons.question_mark, color: Colors.deepOrange.shade500);
    }
  }

  @override
  void initState() {
    super.initState();

    try {
      if(widget.values!['array'] == null) return;
      fillStartLinkToContent();
    } catch (e) {
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
                  child: Text("Ссылка на контент",style: containerLabel,)
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
          const Divider(
            height: 20,
          ),
          RefreshIndicator(
            onRefresh: () async {
              if (listContentStatus == LoadStatus.normal) {
                setState(() {});
              }
            },
            child: SizedBox(
              height: 200,
              child: LoadAny(
                endLoadMore: true,
                footerHeight: 40,
                onLoadMore: loadMore,
                status: listContentStatus,
                bottomTriggerDistance: 200,
                loadingMsg: 'Загрузка',
                errorMsg: 'Ошибка загрузки',
                finishMsg: 'Готово!',
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white24,
                      expandedHeight: 20.0,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: TextField(
                          onSubmitted: ((value) {
                            _actualPage = 0;
                            setState(() {
                              listContentStatus = LoadStatus.loading;
                            });

                            logger.d("${widget._contentItems.map((e) => e.content.title).toList()}");

                            for (var element in widget._contentItems) {
                              if(!element.isSelected() && element.isRemoveble()){
                                logger.w("Deleted: ${element.content.title}");
                                widget._contentItems.remove(element);
                              }else{
                                logger.wtf("Not Deleted: ${element.content.title}");
                              }
                            }


                            if(value.isNotEmpty){
                              loadMore();
                            }else{
                              setState(() {
                                listContentStatus = LoadStatus.normal;
                              });
                            }
                          }),
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Поиск",
                            hintText: "Поиск",
                            focusColor: Theme.of(context).colorScheme.primary,
                            hoverColor: Theme.of(context).colorScheme.primary,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      )),
                    ),
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 4.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                      childCount: widget._contentItems.length,
                        (BuildContext context, int index) {
                          return Row(
                            children: [
                              Checkbox(
                                value: widget._contentItems[index].selected, 
                                onChanged: (bool? val){
                                  setState(() { 
                                    widget._contentItems[index].setSelected(val!);
                                  });
                                }
                              ),
                              getIcon(widget._contentItems[index].content.type),
                              Flexible(child: Text(widget._contentItems[index].content.title,))
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class CheckboxContent{
  CheckboxContent({required this.id, required this.content, required this.removeble});

  final int id;
  final bool removeble;
  bool selected = false;
  final ContentDto content;

  bool isRemoveble(){
    return removeble;
  }

  bool isSelected(){
    return selected;
  }

  void setSelected(bool val){
    selected = val;
  }

  factory CheckboxContent.build(int id, ContentDto content, bool removeble){
    return CheckboxContent(id: id, content: content, removeble: removeble);
  }
}
