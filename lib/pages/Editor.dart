import 'dart:io';
import 'dart:typed_data';

import 'package:citysight_editor/controllers/MapboxDataController.dart';
import 'package:citysight_editor/dto/ContentDto.dart';
import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/enums/ContentType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/ui/AppPanel.dart';
import 'package:citysight_editor/ui/Body.dart';
import 'package:citysight_editor/ui/ListContentItem.dart';
import 'package:citysight_editor/ui/MapboxWidget.dart';
import 'package:citysight_editor/ui/OutlinedContainer.dart';
import 'package:citysight_editor/ui/content_items/Author.dart';
import 'package:citysight_editor/ui/content_items/Contacts.dart';
import 'package:citysight_editor/ui/content_items/CriterionUI.dart';
import 'package:citysight_editor/ui/content_items/Dropzone.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/ui/content_items/Feedbacks.dart';
import 'package:citysight_editor/ui/content_items/Idea.dart';
import 'package:citysight_editor/ui/content_items/LinkToContent.dart';
import 'package:citysight_editor/ui/content_items/Locations.dart';
import 'package:citysight_editor/ui/content_items/MainBox.dart';
import 'package:citysight_editor/ui/content_items/MoreRoutes.dart';
import 'package:citysight_editor/ui/content_items/NotFoundBlock.dart';
import 'package:citysight_editor/ui/content_items/NowEvents.dart';
import 'package:citysight_editor/ui/content_items/OnMap.dart';
import 'package:citysight_editor/ui/content_items/Photos.dart';
import 'package:citysight_editor/ui/content_items/Price.dart';
import 'package:citysight_editor/ui/content_items/Reviews.dart';
import 'package:citysight_editor/ui/content_items/ShortText.dart';
import 'package:citysight_editor/ui/content_items/Sources.dart';
import 'package:citysight_editor/ui/content_items/Tags.dart';
import 'package:citysight_editor/ui/content_items/TextBLock.dart';
import 'package:citysight_editor/ui/content_items/Timework.dart';
import 'package:citysight_editor/ui/content_items/TitleBlock.dart';
import 'package:citysight_editor/utils/ActionsForBlocks.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:loadany/loadany.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../ui/Menu.dart';

/*
    + "main_box": {
        "title": "",
        "image": ""
    },
    + "title": {
        "text": ""
    },
    + "author": {},
    + "dropzone": [],
    + "reviews": {},
    + "feedbacks": {},
    + "idea": {},
    + "bref_desc": {
        "text": ""
    },
    + "text_block": {
        "text": ""
    },
    + "contact": {
        "address": "",
        "phone": "",
        "url": ""
    },

    "criterion": 0,
    "tags": [],
    "location": [],
    "sources": {
        "text": ""
    },
    + "photos": [],
    "on_map": [],
    "scheme_route": {},
    "price": {
        "price": ""
    },
    "eat": [],
    "item": {
        "name": "",
        "image": "",
        "seq_num": 0
    }
     * */

class Editor extends StatefulWidget {
  Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final ScrollController _scrollControllerContent = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _timeStartController = TextEditingController();
  final TextEditingController _timeEndController = TextEditingController();

  final Widget loaderIndicator = const Center(
    child: CircularProgressIndicator(),
  );

  // late MapboxMap mapbox;
  int _actualPage = 0;
  int _selectedID = 0;
  List<int> _tags = [];
  bool _isLockedEditor = false;
  late MapboxDataController mapController = MapboxDataController();
  late Future<List<ContentDto>> _content;
  final Map<String, dynamic> geodata = 
  {
    "markers":[
    ],
    "itinerary":[
    ],
    "property":{
      "places":[

      ]
    }
  }; 
  final List<Symbol> symbols = [];
  List<ContentType> _contentTypeList = [];
  final List<ContentDto> _contentItems = [];
  LoadStatus listContentStatus = LoadStatus.normal;
  LoadStatus contentFrameStatus = LoadStatus.normal;
  ContentType _selectedContentType = ContentType.NONE;
  ContentType _searchContentType = ContentType.NONE;
  final List<ExpandedStatefulWidget> _contentDataItems = [];
  final ValueNotifier<int> _criterion = ValueNotifier<int>(0);
  final ValueNotifier<ActionParam> _dropzoneActions = ValueNotifier<ActionParam>(ActionParam(id: "", action: BlockAction.NONE));
  final List<ExpandedStatefulWidget> _contentDropzoneItems = [];
  final ValueNotifier<bool> _showServices = ValueNotifier<bool>(true);

  Future<void> loadMore() async {
    setState(() {
      listContentStatus = LoadStatus.loading;
    });
    try {
      _actualPage += 1;
      List<ContentDto> contents;
      if (_searchController.text != "") {
        contents = await getContentByQuery(
            _actualPage, _searchController.text);
        listContentStatus = LoadStatus.completed;
      } else {
        contents = await getAllowedContent(_actualPage);
        listContentStatus = LoadStatus.completed;
      }
      listContentStatus = LoadStatus.normal;
      _contentItems.addAll(contents);
      setState(() {});
    } catch (e) {
      listContentStatus = LoadStatus.error;
    }
  }

  void clearArea() {
    setState(() {
      _selectedID = 0;
      _selectedContentType = ContentType.NONE;
      _criterion.value = 0;
      _contentDataItems.clear();
      _contentDropzoneItems.clear();
      _isLockedEditor = false;
      _timeStartController.text = "";
      _timeEndController.text = "";
      mapController.clear();
    });
  }

  void fillByTypeContent(ContentType type){
    setState(() {
      clearArea();
      _selectedContentType = type;
      _isLockedEditor = true;
      switch(type){
        case ContentType.ARTICLE:
          _contentDataItems.add(MainBox());
          _contentDataItems.add(Author(show: _showServices));
          _contentDataItems.add(Dropzone(children: _contentDropzoneItems));
          _contentDataItems.add(Feedbacks(show: _showServices));
          _contentDataItems.add(Idea(show: _showServices));
          _contentDataItems.add(CriterionUI(
                                  criteria: _criterion,
                                  values: {
                                    "type": _selectedContentType
                                  }
                                ));
          _contentDataItems.add(Tags(
                                  criteria: _criterion, 
                                  values: {
                                    "array": List.empty(),
                                  },
                                )
                              );
          _contentDataItems.add(Sources());
          break;
        case ContentType.EVENT:
          _contentDataItems.add(MainBox());
          _contentDataItems.add(ShortText(action: _dropzoneActions,));
          _contentDataItems.add(Dropzone(children: _contentDropzoneItems));
          _contentDataItems.add(Price(action: _dropzoneActions,));
          _contentDataItems.add(Locations(action: _dropzoneActions,));
          _contentDataItems.add(Feedbacks(show: _showServices));
          _contentDataItems.add(Idea(show: _showServices));
          _contentDataItems.add(CriterionUI(
                                  criteria: _criterion,
                                  values: {
                                    "type": _selectedContentType
                                  }
                                ));
          _contentDataItems.add(Tags(
                                  criteria: _criterion, 
                                  values: {
                                    "array": List.empty(),
                                  },
                                )
                              );
          _contentDataItems.add(Sources());
          break;
        case ContentType.PLACE:
          _contentDataItems.add(MainBox());
          _contentDataItems.add(ShortText(action: _dropzoneActions,));
          _contentDataItems.add(Dropzone(children: _contentDropzoneItems));
          _contentDataItems.add(NowEvents(show: _showServices));
          _contentDataItems.add(Timework());
          _contentDataItems.add(Contacts());
          _contentDataItems.add(OnMap(show: _showServices));
          _contentDataItems.add(MoreRoutes(show: _showServices));
          _contentDataItems.add(CriterionUI(
                                  criteria: _criterion,
                                  values: {
                                    "type": _selectedContentType
                                  }
                                ));
          _contentDataItems.add(Tags(
                                  criteria: _criterion, 
                                  values: {
                                    "array": List.empty(),
                                  },
                                )
                              );
          _contentDataItems.add(Sources());
          break;
        // case:
        default:
          return;
      }
    });
  }

  void contentLoad(int index) {
    setState(() {
      clearArea();
      contentFrameStatus = LoadStatus.loading;
    });

    setState(() {
      ContentDto card = _contentItems[index];

      _selectedID = card.id;
      _selectedContentType = card.type;
      _criterion.value = card.criterion.id;
      _timeStartController.text = card.timeStart.toString().length == 16 ? card.timeStart.toString().substring(0, 16) : "";
      _timeEndController.text = card.timeEnd.toString().length == 16 ? card.timeEnd.toString().substring(0, 16) : "";

      Map<String, dynamic> geodata = jsonDecode(card.geodata);
      mapController.add(geodata);

      Iterable listWidgets = jsonDecode(card.data);
      for (Map<String, dynamic> item in listWidgets) {
        _contentDataItems.add(getItemByName(item, false));
      }

      _isLockedEditor = true;
      contentFrameStatus = LoadStatus.normal;
    });
  }

  void savedContent(BuildContext mainContext, BuildContext context) async{


    String title = "";
    String image = "";
    List<int> tags = [];

    var contentMap = [];
    _contentDataItems.forEach((element) {
      ExpandedStatefulWidget widget = element as ExpandedStatefulWidget;
      if (widget.type == BlockType.MAP) {
        logger.d("Get (${widget.idBlock}): ${widget.toJson()}");
        if(widget.idBlock == "main_box"){
          title = widget.toJson()["title"];
          image = widget.toJson()["image"];
        }
        contentMap.add({widget.idBlock: widget.toJson()});
      } else if (widget.type == BlockType.ARRAY) {
        logger.d("Get (${widget.idBlock}): ${widget.toArrayJson()}");
        if(widget.idBlock == "tags"){
          tags = widget.toArrayJson().map<int>((e) {
            try{
              return int.parse(e);
            }catch(er){
              return e;
            }
          }).toList();
        }
        contentMap.add({widget.idBlock: widget.toArrayJson()});
      } else if (widget.type == BlockType.INT){
        logger.d("Get (${widget.idBlock}): ${widget.toJson()['int']}");
        contentMap.add({widget.idBlock: widget.toJson()['int']});
      }
    });

    bool saved = await saveContent(
      _selectedID,
      _selectedContentType,
      title,
      image,
      contentMap,
      mapController.getData(),
      _criterion.value,
      tags,
      _timeStartController.text,
      _timeEndController.text
    );
    

    clearArea();
    _isLockedEditor = false;
    Navigator.of(context).pop();
    Navigator.pushReplacement(mainContext, MaterialPageRoute(builder: (mainContext) => Editor()));
  }

  void showMap(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Center(
          child: SizedBox(
            width: 1600,
            height: 800,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade100, width: 8),
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 10,
                      spreadRadius: 6,
                      color: Colors.black87,
                      inset: true,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: MapboxWidget(controller: mapController,)
              ),
            ),
          ),
        );        
      }              
    );
  }

  List<Widget> menuButtons(ContentType type) {
    switch(type){
      case ContentType.ARTICLE:
        return [
            IconButton(icon: Icon(Icons.title, color: Colors.white,), onPressed: () {
              setState(() {
              _contentDropzoneItems.add(TitleBlock(action: _dropzoneActions, inDropzone: true,));
              });
            }),
            IconButton(icon: Icon(Icons.short_text, color: Colors.white,), onPressed: () {
              setState(() {
              _contentDropzoneItems.add(ShortText(action: _dropzoneActions, inDropzone: true,));
              });
            }),
            IconButton(icon: Icon(Icons.subject, color: Colors.white,), onPressed: () {
              setState(() {
              _contentDropzoneItems.add(TextBlock(action: _dropzoneActions, inDropzone: true,));
              });
            }),
            IconButton(icon: Icon(Icons.photo_camera, color: Colors.white,), onPressed: () {
              setState(() {
              _contentDropzoneItems.add(Photos(action: _dropzoneActions, inDropzone: true,));
              });
            }),
            IconButton(icon: Icon(Icons.link, color: Colors.white,), onPressed: () {
              setState(() {
              _contentDropzoneItems.add(LinkToContent(action: _dropzoneActions, inDropzone: true,));
              });
            }),
            IconButton(icon: Icon(Icons.contact_support, color: Colors.white,), onPressed: () {
              setState(() {
              _contentDropzoneItems.add(Contacts(action: _dropzoneActions, inDropzone: true,));
              });
            }),
            IconButton(icon: Icon(Icons.map, color: Colors.white,), onPressed: () {
              showMap();
            }),
        ];
      case ContentType.EVENT:
        return [
          IconButton(icon: Icon(Icons.subject, color: Colors.white,), onPressed: () {
            setState(() {
            _contentDropzoneItems.add(TextBlock(action: _dropzoneActions, inDropzone: true,));
            });
          }),
          IconButton(icon: Icon(Icons.photo_camera, color: Colors.white,), onPressed: () {
            setState(() {
            _contentDropzoneItems.add(Photos(action: _dropzoneActions, inDropzone: true,));
            });
          }),
          IconButton(icon: Icon(Icons.map, color: Colors.white,), onPressed: () {
              showMap();
          }),
        ];
      case ContentType.PLACE:
        return [
          IconButton(icon: Icon(Icons.subject, color: Colors.white,), onPressed: () {
            setState(() {
            _contentDropzoneItems.add(TextBlock(action: _dropzoneActions, inDropzone: true,));
            });
          }),
          IconButton(icon: Icon(Icons.photo_camera, color: Colors.white,), onPressed: () {
            setState(() {
            _contentDropzoneItems.add(Photos(action: _dropzoneActions, inDropzone: true,));
            });
          }),
          IconButton(icon: Icon(Icons.currency_ruble, color: Colors.white,), onPressed: () {
            setState(() {
            _contentDropzoneItems.add(Price(action: _dropzoneActions, inDropzone: true,));
            });
          }),
          IconButton(icon: Icon(Icons.map, color: Colors.white,), onPressed: () {
              showMap();
          }),
        ];
      default:
        return []; 
    }
  }

  ExpandedStatefulWidget getItemByName(obj, isDropzone) {
    logger.d("Name: ${obj.keys.first} Data: ${obj.values.first}");
    switch (obj.keys.first) {
      case "author":
        return Author(
          show: _showServices,
        );
      case "on_map":
        return OnMap(
          show: _showServices,
        );
      case "now_events":
        return NowEvents(
          show: _showServices,
        );
      case "more_routes":
        return MoreRoutes(
          show: _showServices,
        );
      case "timework":
        return Timework(
          action: _dropzoneActions,
          values: obj.values.first,
          inDropzone: isDropzone,
        );
      case "idea":
        return Idea(
          show: _showServices,
        );
      case "reviews":
        return Reviews(
          show: _showServices,
        );
      case "feedbacks":
        return Feedbacks(
          show: _showServices,
        );
      case "photos":
        return Photos(
          action: _dropzoneActions,
          values: {"array": obj.values.first},
          inDropzone: isDropzone,
        );
      case "location":
        return Locations(
          action: _dropzoneActions,
          values: {"array": obj.values.first},
          inDropzone: isDropzone,
        );
      case "content_box":
        return LinkToContent(
          action: _dropzoneActions,
          values: {"array": obj.values.first},
          inDropzone: isDropzone,
        );
      case "main_box":
        return MainBox(
          values: obj.values.first
        );
      case "contact":
        return Contacts(
          action: _dropzoneActions,
          values: obj.values.first,
          inDropzone: isDropzone,
        );
      case "price":
        return Price(
          action: _dropzoneActions,
          values: obj.values.first,
          inDropzone: isDropzone,
        );
      case "bref_desc":
        return ShortText(
          action: _dropzoneActions,
          values: obj.values.first,
          inDropzone: isDropzone,
        );
      case "sources":
        return Sources(
          values: obj.values.first
        );
      case "text_block":
        return TextBlock(
          action: _dropzoneActions,
          values: obj.values.first,
          inDropzone: isDropzone,
        );
      case "title":
        return TitleBlock(
          action: _dropzoneActions,
          values: obj.values.first,
          inDropzone: isDropzone,
        );
      case "criterion":
        return CriterionUI(
          criteria: _criterion,
          values: {
            "type": _selectedContentType
          }
        );
      case "tags":
        return Tags(
          criteria: _criterion,
          values: {
            "array": obj.values.first,
          },
        );
      case "dropzone":
        Iterable dropItems = obj.values.first;
        for (Map<String, dynamic> item in dropItems) {
          _contentDropzoneItems.add(getItemByName(item, true));
        }
        return Dropzone(
          children: _contentDropzoneItems,
        );
      default:
        return NotFound(show: _showServices, name: obj.keys.first);
    }
  }

  @override
  void initState() {

    for (ContentType value in ContentType.values) {
      _contentTypeList.add(value);
    }

    _content = getAllowedContent(_actualPage);
    _content.then((value) => {_contentItems.addAll(value), setState(() {})});

    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {

    _dropzoneActions.addListener(() {
      if(_dropzoneActions.value.action != BlockAction.NONE){
        print("${_dropzoneActions.value.id} - ${_dropzoneActions.value.action}");

        for(int i = 0; i < _contentDropzoneItems.length; i++){
          print("${_contentDropzoneItems[i].uuid} == ${_dropzoneActions.value.id} == ${_contentDropzoneItems[i].uuid == _dropzoneActions.value.id}");
          if(_contentDropzoneItems[i].uuid == _dropzoneActions.value.id){

            if(_dropzoneActions.value.action == BlockAction.UP){
              print("UP $i");
              if(i == 0) break;
              ExpandedStatefulWidget targetWidget = _contentDropzoneItems[i];
              ExpandedStatefulWidget movableWidget = _contentDropzoneItems[i - 1];
              _contentDropzoneItems[i - 1] = targetWidget;
              _contentDropzoneItems[i] = movableWidget;
              break;
            }
            else if(_dropzoneActions.value.action == BlockAction.DOWN){
              print("DOWN $i");
              if(i == _contentDropzoneItems.length - 1) break;
              ExpandedStatefulWidget targetWidget = _contentDropzoneItems[i];
              ExpandedStatefulWidget movableWidget = _contentDropzoneItems[i + 1];
              _contentDropzoneItems[i + 1] = targetWidget;
              _contentDropzoneItems[i] = movableWidget;
              break;
            }
            else if(_dropzoneActions.value.action == BlockAction.DELETE){
              print("DELETE $i");
              _contentDropzoneItems.removeAt(i);
              break;
            }
          }
        }
        _dropzoneActions.value = ActionParam(id: "", action: BlockAction.NONE);
        setState(() {});
      }
    },);
    return AppPanel(
      body: Body(
        isFullscreen: true,
        widget: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedContainer(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if (listContentStatus == LoadStatus.normal) {
                            setState(() {});
                          }
                        },
                        child: SizedBox(
                          height: MediaQuery.of(mainContext).size.height - 92,
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: TextField(
                                            onSubmitted: ((value) {
                                              _actualPage = 0;
                                              _contentItems.clear();
                                              listContentStatus = LoadStatus.loading;

                                              if (value != "" || _searchContentType != ContentType.NONE) {
                                                
                                                if(_searchContentType == ContentType.NONE){
                                                  getContentByQuery(_actualPage, value != "" ? value:" ")
                                                  .then((value) => {
                                                    _contentItems.addAll(value),
                                                    setState(() {
                                                      listContentStatus =
                                                          LoadStatus.normal;
                                                    })
                                                  });
                                                }else{
                                                  getContentByQueryAndByType(_actualPage, _searchContentType, value != "" ? value:" ")
                                                  .then((value) => {
                                                    _contentItems.addAll(value),
                                                    setState(() {
                                                      listContentStatus =
                                                          LoadStatus.normal;
                                                    })
                                                  });
                                                }

                                              } else {
                                                loadMore();
                                              }
                                              setState(() {});
                                            }),
                                            controller: _searchController,
                                            decoration: InputDecoration(
                                              labelText: "Поиск",
                                              hintText: "Поиск",
                                              focusColor: Theme.of(mainContext)
                                                  .colorScheme
                                                  .primary,
                                              hoverColor: Theme.of(mainContext)
                                                  .colorScheme
                                                  .primary,
                                              border: const OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 70,
                                            child: DropdownButton<ContentType>(
                                              isExpanded: true,
                                              value: _searchContentType,
                                              items: _contentTypeList
                                                  .map((ContentType type) {
                                                ContentTypeName thisName = ContentTypeName.thisName(type);
                                                return DropdownMenuItem<ContentType>(
                                                  value: thisName.type,
                                                  child: Text(thisName.name),
                                                );
                                              }).toList(),
                                              onChanged: (ContentType? value) {
                                                setState(() {
                                                  _searchContentType = value ?? ContentType.NONE;
                                                });
                                              },
                                            ),
                                          )
                                        )
                                      ],
                                    )
                                  )),
                                ),
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  childCount: _contentItems.length,
                                  (BuildContext context, int index) {
                                    return ListContentItem(
                                      content: _contentItems[index],
                                      onEdit: () {
                                        if (!_isLockedEditor) {
                                          contentLoad(index);
                                        } else {
                                          showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button for close dialog!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Ошибка'),
                                                content: const Text('У вас имеется открытая редакция. Сохраните или закройте ее.'),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: const Text('Понятно'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedContainer(
                              padding: 0.0,
                              minimal: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: DropdownButton<ContentType>(
                                      isExpanded: true,
                                      value: _selectedContentType,
                                      items: _contentTypeList
                                          .map((ContentType type) {
                                        ContentTypeName thisName = ContentTypeName.thisName(type);
                                        return DropdownMenuItem<ContentType>(
                                          value: thisName.type,
                                          child: Text(thisName.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (_isLockedEditor) {
                                          showDialog(
                                            context: mainContext,
                                            barrierDismissible: false, // user must tap button for close dialog!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Внимание!'),
                                                content: const Text('Вы можете потерять данные. Вы уверены?'),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: const Text('Да'),
                                                    onPressed: () {
                                                      setState(() {
                                                        fillByTypeContent(value!);
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text('Нет'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          fillByTypeContent(value!);
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      mainTheme
                                                          .colorScheme.primary),
                                              value: _showServices.value,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _showServices.value = value!;
                                                });
                                              }),
                                          const Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              "Показывать служебные блоки?"
                                            ),
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: DateTimePicker(
                                              readOnly: !_isLockedEditor,
                                              type: DateTimePickerType.dateTime,
                                              dateMask: 'd MMM yy HH:mm',
                                              controller: _timeStartController,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                              icon: const Icon(Icons.event),
                                              dateLabelText: 'Дата начала',
                                              timeLabelText: "Время",
                                              locale: const Locale("ru"),
                                              use24HourFormat: true,
                                              selectableDayPredicate: (date) {
                                                // Disable weekend days to select from the calendar
                                                // if (date.weekday == 6 || date.weekday == 7) {
                                                //   return false;
                                                // }
                                                return true;
                                              },
                                              onChanged: (val) => print("Change: $val"),
                                              validator: (val) {
                                                return null;
                                              },
                                              onSaved: (val) {},
                                            ),
                                          ),
                                          Expanded(
                                            child: DateTimePicker(
                                              readOnly: !_isLockedEditor,
                                              type: DateTimePickerType.dateTime,
                                              dateMask: 'd MMM yy HH:mm',
                                              controller: _timeEndController,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                              icon: const Icon(Icons.event),
                                              dateLabelText: 'Дата конца',
                                              timeLabelText: "Время",
                                              locale: const Locale("ru"),
                                              use24HourFormat: true,
                                              selectableDayPredicate: (date) {
                                                // Disable weekend days to select from the calendar
                                                // if (date.weekday == 6 || date.weekday == 7) {
                                                //   return false;
                                                // }
                                                return true;
                                              },
                                              onChanged: (val) => print("Change: $val"),
                                              validator: (val) {
                                                return null;
                                              },
                                              onSaved: (val) {},
                                            ),
                                          ),
                                        ],
                                      )),
                                  OutlinedButton(child: const Icon(Icons.delete), onPressed: (){ 
                                      setState(() {
                                        _timeStartController.text = "";
                                        _timeEndController.text = "";
                                      });
                                    },
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: mainContext,
                                                  barrierDismissible:
                                                      false, // user must tap button for close dialog!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Внимание!'),
                                                      content: const Text(
                                                          'Данное действие повлечет изменение данных. Вы уверены?'),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child:
                                                              const Text('Да'),
                                                          onPressed: () => savedContent(mainContext, context),
                                                        ),
                                                        ElevatedButton(
                                                          child:
                                                              const Text('Нет'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Text("Сохранить")),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: mainContext,
                                                  barrierDismissible:
                                                      false, // user must tap button for close dialog!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Внимание!'),
                                                      content: const Text(
                                                          'Вы уверены? Вы можете потерять данные!'),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child: const Text(
                                                              'Забыть изменения'),
                                                          onPressed: () {
                                                            clearArea();
                                                            _isLockedEditor =
                                                                false;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          child: const Text(
                                                              'Отмена'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child:
                                                  const Text("Не сохранять")),
                                        ],
                                      ))
                                ],
                              )),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onLongPress: (){
                              if(!_isLockedEditor) return;
                              showDialog(
                                barrierColor: null,
                                context: context, 
                                builder: (c){
                                  return SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: FabCircularMenu(
                                      ringDiameter: 256,
                                      ringColor: mainTheme.colorScheme.primary,
                                      alignment: Alignment.center,
                                      children: menuButtons(_selectedContentType)
                                    ),
                                  );
                                }
                              );
                            },
                            child: OutlinedContainer(
                              child: SizedBox(
                                  height:MediaQuery.of(mainContext).size.height - 152,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      controller: _scrollControllerContent,
                                      // shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: _contentDataItems.length,
                                      itemBuilder: (context, index) {
                                        // print(_contentDataItems[index].toJson());
                                        if(_contentDataItems[index].idBlock == "dropzone"){
                                          _contentDataItems[index] = Dropzone(children: _contentDropzoneItems,);
                                        }
                                        return _contentDataItems[index];
                                      },
                                    )
                                  ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
