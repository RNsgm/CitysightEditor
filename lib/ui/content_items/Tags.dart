import 'package:citysight_editor/dto/Criterion.dart';
import 'package:citysight_editor/dto/Tag.dart';
import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/enums/ContentType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';

class Tags extends ExpandedStatefulWidget {
  Tags({Key? key, this.values, required this.criteria}) : super(key: key);

  @override
  String idBlock = "tags";

  @override
  BlockType type = BlockType.ARRAY;

  @override
  Map<String, dynamic>? values;

  final ValueNotifier<int> criteria;

  @override
  State<Tags> createState() => _TagsState();

  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{};
    return values!;
  }

  @override
  List toArrayJson() {
    return values!["array"];
  }
}

class _TagsState extends State<Tags> with AutomaticKeepAliveClientMixin {
  List<CheckboxTag> _checkboxesTags = [];

  int criteria = 0;
  int prevCriteria = 0;

  void fillTags(List<Tag> tags) async {
    _checkboxesTags = [];
    for (Tag t in tags) {
      _checkboxesTags
          .add(CheckboxTag.build(t.id, t));
    }
  }

  void asyncFillTags() async{
    List<Tag> tags = await getTagForCriteria(criteria);
    setState(() {
      fillTags(tags);
    });
    return;    
  }

  @override
  void initState() {
    super.initState();
    criteria = widget.criteria.value;
    try {

      Future.delayed(Duration.zero, () async {
        List<Tag> tags = await getTagForCriteria(widget.criteria.value);
        fillTags(tags);

        if(widget.values!["array"] != null){
          List<int> ids = widget.values!["array"].map((e) => int.tryParse(e.toString())).toList().cast<int>();
         
          if(ids.isEmpty) return;
          
          for(CheckboxTag ct in _checkboxesTags){
            if(ids.contains(ct.id)){
              ct.setSelected(true);
            }
          }
        }
        setState(() {});
      });
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
          Text(
            "Теги",
            style: containerLabel,
          ),
          const Divider(
            height: 20,
          ),
          ValueListenableBuilder(
            valueListenable: widget.criteria, 
            builder: (context, value, _) {
              criteria = widget.criteria.value;
              if(prevCriteria != criteria){
              _checkboxesTags = [];
                asyncFillTags();
                prevCriteria = criteria;
              }
              return SizedBox(
                height: 200,
                child: GridView.custom(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 4.0,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    childCount: _checkboxesTags.length,
                    (BuildContext context, int index) {
                      return Row(
                        children: [
                          Checkbox(
                            value: _checkboxesTags[index].selected,
                            onChanged: (bool? val) {
                              setState(() {
                                _checkboxesTags[index].setSelected(val!);
                                widget.values!["array"] = [];
                                for(CheckboxTag tag in _checkboxesTags){
                                  if(tag.isSelected()) {
                                    widget.values!["array"].add(tag.id);
                                  }
                                }
                              });
                            }),
                          Flexible(
                            child: Text(_checkboxesTags[index].tag.name_ru))
                        ],
                      );
                    },
                  )
                ),
              );
            }
          ),
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class CheckboxTag {
  CheckboxTag({required this.id, required this.tag});

  final int id;
  bool selected = false;
  final Tag tag;

  bool isSelected() {
    return selected;
  }

  void setSelected(bool val) {
    selected = val;
  }

  factory CheckboxTag.build(int id, Tag tag) {
    return CheckboxTag(id: id, tag: tag);
  }
}
