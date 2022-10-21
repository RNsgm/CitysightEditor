import 'package:citysight_editor/dto/ContentDto.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListContentItem extends StatelessWidget {
  ListContentItem({Key? key, required this.content, required this.onEdit}) : super(key: key);

  ContentDto content;
  Function()? onEdit;

  final Color _borderContainerColor = Colors.black12;
  final Color _borderContainerShadowColor = Colors.black12;

  String getAllowName(int i){
    Map<int, String> allowNames = {
      0: "В работе", 
      1: "На модерации",
      2: "Исправить",
      3: "Опубликовано",
      4: "Отозвано",
    }; 
    return allowNames[i]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        child: InkWell(
        onTap: () {}, 
        onHover: (value) {
        },
        child: Container(
          padding: const EdgeInsets.all(7.0),
          decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _borderContainerColor, width: 2),
          borderRadius: BorderRadius.circular(7.0),
          boxShadow: [
              BoxShadow(
                color: _borderContainerShadowColor,
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Image.network("$baseContentUrl/img/${content.markerImage}", width: 100.0, height: 100.0,),
              ),
              Container(width: 10.0,),
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  overflow: TextOverflow.ellipsis,
                  content.title,
                  style: const TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                  const Divider(height: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit, 
                        label: const Text("Изменить"),
                        ),
                      const SizedBox(height: 8,),
                      Text(getAllowName(content.allow), style: GoogleFonts.comfortaa(fontSize: 14),)
                    ],
                  )
                ],
              )
              ),
            ],
          ),
        )
      ),
    );
  }
}