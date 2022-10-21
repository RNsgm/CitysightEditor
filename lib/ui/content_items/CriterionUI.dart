import 'package:citysight_editor/dto/Criterion.dart';
import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/enums/ContentType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';

class CriterionUI extends ExpandedStatefulWidget {
  CriterionUI({Key? key, this.values, required this.criteria}) : super(key: key);

  @override
  String idBlock = "criterion";
  @override
  BlockType type = BlockType.INT;

  @override
  Map<String, dynamic>? values;

    final ValueNotifier<int> criteria;

  @override
  State<CriterionUI> createState() => _CriterionUIState();

  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{"int":0};
    values!['int'] = criteria.value;
    return values!;
  }

  @override
  List toArrayJson() {
    return [];
  }
}

class _CriterionUIState extends State<CriterionUI>  with AutomaticKeepAliveClientMixin{
  List<CheckboxCriterion> _checkboxesCriterion = [];

  void fillAndSelectCriterion(int selected, ContentType type) async {
    List<Criterion> criterions = await getCriterionByType(type);

    for (Criterion c in criterions) {
      _checkboxesCriterion
          .add(CheckboxCriterion.build(c.id, c, c.id == selected));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    try {
      int selectedCriterion = widget.criteria.value;
      ContentType type = widget.values!["type"];
      fillAndSelectCriterion(selectedCriterion, type);
    } catch (e) {}
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
            "Критерий",
            style: containerLabel,
          ),
          const Divider(
            height: 20,
          ),
          SizedBox(
            height: 200,
            child: GridView.custom(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: _checkboxesCriterion.length,
                (BuildContext context, int index) {
                  return Row(
                    children: [
                      Checkbox(
                        value: _checkboxesCriterion[index].selected,
                        onChanged: (bool? val) {
                          setState(() {
                            for(CheckboxCriterion c in _checkboxesCriterion){
                              c.setSelected(false);
                            }

                            _checkboxesCriterion[index].setSelected(val!);
                            widget.criteria.value = _checkboxesCriterion[index].id;
                          });
                        }),
                      Flexible(
                        child: Text(_checkboxesCriterion[index].criterion.nameRu))
                    ],
                  );
                },
              )
            ),
          )
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class CheckboxCriterion {
  CheckboxCriterion({required this.id, required this.criterion});

  final int id;
  bool selected = false;
  final Criterion criterion;

  bool isSelected() {
    return selected;
  }

  void setSelected(bool val) {
    selected = val;
  }

  factory CheckboxCriterion.build(int id, Criterion criterion, bool selected) {
    var c = CheckboxCriterion(id: id, criterion: criterion);
    c.setSelected(selected);
    return c;
  }
}
