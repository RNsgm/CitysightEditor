import 'package:citysight_editor/enums/BlockType.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/content_items/ExpandedStatefulWidget.dart';
import 'package:citysight_editor/utils/ActionsForBlocks.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class Timework extends ExpandedStatefulWidget {
  Timework({Key? key, this.values, this.action, this.inDropzone = false}) : super(key: key);

  @override
  String idBlock = "timework";
  @override
  BlockType type = BlockType.MAP;
    
  @override
  Map<String, dynamic>? values;
  final ValueNotifier<ActionParam>? action;

  @override
  String uuid = Uuid().v1();

  TextEditingController mo_from = TextEditingController();
  TextEditingController mo_to = TextEditingController();
  TextEditingController tu_from = TextEditingController();
  TextEditingController tu_to = TextEditingController();
  TextEditingController we_from = TextEditingController();
  TextEditingController we_to = TextEditingController();
  TextEditingController th_from = TextEditingController();
  TextEditingController th_to = TextEditingController();
  TextEditingController fr_from = TextEditingController();
  TextEditingController fr_to = TextEditingController();
  TextEditingController sa_from = TextEditingController();
  TextEditingController sa_to = TextEditingController();
  TextEditingController su_from = TextEditingController();
  TextEditingController su_to = TextEditingController();
  
  TextEditingController mo_from_t = TextEditingController();
  TextEditingController mo_to_t = TextEditingController();
  TextEditingController tu_from_t = TextEditingController();
  TextEditingController tu_to_t = TextEditingController();
  TextEditingController we_from_t = TextEditingController();
  TextEditingController we_to_t = TextEditingController();
  TextEditingController th_from_t = TextEditingController();
  TextEditingController th_to_t = TextEditingController();
  TextEditingController fr_from_t = TextEditingController();
  TextEditingController fr_to_t = TextEditingController();
  TextEditingController sa_from_t = TextEditingController();
  TextEditingController sa_to_t = TextEditingController();
  TextEditingController su_from_t = TextEditingController();
  TextEditingController su_to_t = TextEditingController();

  bool inDropzone;

  @override
  State<Timework> createState() => _TimeworkState();
  
  @override
  Map<String, dynamic> toJson() {
    values = <String, dynamic>{
      "mo-from":mo_from.text,
      "mo-to":mo_to.text,
      "tu-from":tu_from.text,
      "tu-to":tu_to.text,
      "we-from":we_from.text,
      "we-to":we_to.text,
      "th-from":th_from.text,
      "th-to":th_to.text,
      "fr-from":fr_from.text,
      "fr-to":fr_to.text,
      "sa-from":sa_from.text,
      "sa-to":sa_to.text,
      "su-from":su_from.text,
      "su-to":su_to.text,
      "mo-from-t":mo_from_t.text,
      "mo-to-t":mo_to_t.text,
      "tu-from-t":tu_from_t.text,
      "tu-to-t":tu_to_t.text,
      "we-from-t":we_from_t.text,
      "we-to-t":we_to_t.text,
      "th-from-t":th_from_t.text,
      "th-to-t":th_to_t.text,
      "fr-from-t":fr_from_t.text,
      "fr-to-t":fr_to_t.text,
      "sa-from-t":sa_from_t.text,
      "sa-to-t":sa_to_t.text,
      "su-from-t":su_from_t.text,
      "su-to-t":su_to_t.text
    };

    return values!;
  }

  @override
  List toArrayJson() {
    return [];
  }
}

class _TimeworkState extends State<Timework> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    Map<String, dynamic> values = widget.values ?? {};
    widget.mo_from.text = values["mo-from"] ?? "";
    widget.mo_to.text = values["mo-to"] ?? "";
    widget.tu_from.text = values["tu-from"] ?? "";
    widget.tu_to.text = values["tu-to"] ?? "";
    widget.we_from.text = values["we-from"] ?? "";
    widget.we_to.text = values["we-to"] ?? "";
    widget.th_from.text = values["th-from"] ?? "";
    widget.th_to.text = values["th-to"] ?? "";
    widget.fr_from.text = values["fr-from"] ?? "";
    widget.fr_to.text = values["fr-to"] ?? "";
    widget.sa_from.text = values["sa-from"] ?? "";
    widget.sa_to.text = values["sa-to"] ?? "";
    widget.su_from.text = values["su-from"] ?? "";
    widget.su_to.text = values["su-to"] ?? "";
    widget.mo_from_t.text = values["mo-from-t"] ?? "";
    widget.mo_to_t.text = values["mo-to-t"] ?? "";
    widget.tu_from_t.text = values["tu-from-t"] ?? "";
    widget.tu_to_t.text = values["tu-to-t"] ?? "";
    widget.we_from_t.text = values["we-from-t"] ?? "";
    widget.we_to_t.text = values["we-to-t"] ?? "";
    widget.th_from_t.text = values["th-from-t"] ?? "";
    widget.th_to_t.text = values["th-to-t"] ?? "";
    widget.fr_from_t.text = values["fr-from-t"] ?? "";
    widget.fr_to_t.text = values["fr-to-t"] ?? "";
    widget.sa_from_t.text = values["sa-from-t"] ?? "";
    widget.sa_to_t.text = values["sa-to-t"] ?? "";
    widget.su_from_t.text = values["su-from-t"] ?? "";
    widget.su_to_t.text = values["su-to-t"] ?? "";
    super.initState();
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
          Text("Время работы",style: containerLabel,),
          const Divider(height: 20,),
          SizedBox(
            height: 400,
            child: GridView.count(
              childAspectRatio: 1.9,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              crossAxisCount: 3,
              children: [
                DayBlock(name_day: "Понедельник", from: widget.mo_from, to: widget.mo_to, break_from: widget.mo_from_t, break_to: widget.mo_to_t),
                DayBlock(name_day: "Вторник", from: widget.tu_from, to: widget.tu_to, break_from: widget.tu_from_t, break_to: widget.tu_to_t),
                DayBlock(name_day: "Среда", from: widget.we_from, to: widget.we_to, break_from: widget.we_from_t, break_to: widget.we_to_t),
                DayBlock(name_day: "Четверг", from: widget.th_from, to: widget.th_to, break_from: widget.th_from_t, break_to: widget.th_to_t),
                DayBlock(name_day: "Пятница", from: widget.fr_from, to: widget.fr_to, break_from: widget.fr_from_t, break_to: widget.fr_to_t),
                DayBlock(name_day: "Суббота", from: widget.sa_from, to: widget.sa_to, break_from: widget.sa_from_t, break_to: widget.sa_to_t),
                DayBlock(name_day: "Воскресение", from: widget.su_from, to: widget.su_to, break_from: widget.su_from_t, break_to: widget.su_to_t),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
class DayBlock extends StatefulWidget {
  DayBlock({Key? key, required this.name_day, required this.from, required this.to, required this.break_from, required this.break_to}) : super(key: key);
  TextEditingController from;
  TextEditingController to;
  TextEditingController break_from;
  TextEditingController break_to;

  String name_day;

  @override
  State<DayBlock> createState() => _DayBlockState();
}

class _DayBlockState extends State<DayBlock> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name_day, 
              style: GoogleFonts.comfortaa(fontSize: 16.0)
            ),
            Row(
              children: [
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.time,
                    dateMask: 'HH:mm',
                    controller: widget.from,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    timeLabelText: "Открытие",
                    locale: const Locale("ru"),
                    use24HourFormat: true,
                    selectableDayPredicate: (date) {
                      return true;
                    },
                    onChanged: (val) {widget.from.text = val;},
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) {},
                  ),
                ),
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.time,
                    dateMask: 'HH:mm',
                    controller: widget.to,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    timeLabelText: "Закрытие",
                    locale: const Locale("ru"),
                    use24HourFormat: true,
                    selectableDayPredicate: (date) {
                      return true;
                    },
                    onChanged: (val) {widget.to.text = val;},
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Перерыв",
              style: GoogleFonts.comfortaa(fontSize: 12.0)
            ),
            Row(
              children: [
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.time,
                    dateMask: 'HH:mm',
                    controller: widget.break_from,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    timeLabelText: "Начало",
                    locale: const Locale("ru"),
                    use24HourFormat: true,
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      // if (date.weekday == 6 || date.weekday == 7) {
                      //   return false;
                      // }
                      return true;
                    },
                    onChanged: (val) {widget.break_from.text = val;},
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) {},
                  ),
                ),
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.time,
                    dateMask: 'HH:mm',
                    controller: widget.break_to,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    timeLabelText: "Конец",
                    locale: const Locale("ru"),
                    use24HourFormat: true,
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      // if (date.weekday == 6 || date.weekday == 7) {
                      //   return false;
                      // }
                      return true;
                    },
                    onChanged: (val) {widget.break_to.text = val;},
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() {
                    widget.from.text = "00:00";
                    widget.to.text = "24:00";
                    }), 
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade500)), 
                  child: const Text("Круглосуточно", style: TextStyle(color: Colors.white),)
                ),
                const SizedBox(width: 4,),
                ElevatedButton(
                  onPressed: () => setState(() {
                    widget.from.text = "00:00";
                    widget.to.text = "00:00";
                    }), 
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade500)), 
                  child: const Text("Закрыто", style: TextStyle(color: Colors.white),)
                ),
                const SizedBox(width: 16,),
                ElevatedButton(
                  onPressed: () => setState(() {
                    widget.break_from.text = "";
                    widget.break_to.text = "";
                    }), 
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade500)), 
                  child: const Text("Без перерывов", style: TextStyle(color: Colors.white),)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}