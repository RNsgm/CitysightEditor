import 'dart:convert';
import 'dart:io';

import 'package:citysight_editor/dto/Criterion.dart';
import 'package:citysight_editor/enums/ContentType.dart';
import 'package:citysight_editor/enums/Status.dart';

class ContentDto{

  ContentDto({
    required this.id,
    required this.type,
    required this.title,
    required this.author,
    required this.data,
    required this.markerImage,
    required this.geodata,
    required this.criterion,
    required this.allow,
    required this.moderator,
    required this.timeStart,
    required this.timeEnd,
    required this.tags,
    required this.likes,
    required this.created,
    required this.updated,
    required this.status,
  });

  int id;
  ContentType type;
  String title;
  int author;
  String data;
  String markerImage;
  String geodata;
  Criterion criterion;
  int allow;
  int moderator;
  DateTime? timeStart;
  DateTime? timeEnd;
  Set<int> tags;
  int likes;
  DateTime created;
  DateTime updated;
  Status status;

  factory ContentDto.fromJson(Map<String, dynamic> json){
    Iterable tags = json['tags'];
    DateTime? start;
    DateTime? end;
    try{
      start = DateTime.parse(json['timeStart']);
      end = DateTime.parse(json['timeEnd']);
    }catch(e){}

    return ContentDto(
      id: json['id'], 
      type: ContentType.values.firstWhere((element) => element.name == json['type']), 
      title: json['title'], 
      author: json['author'], 
      data: json['data'], 
      markerImage: json['markerImage'], 
      geodata: json['geodata'], 
      criterion: Criterion.fromJson(json['criterion']), 
      allow: json['allow'], 
      moderator: json['moderator'], 
      timeStart: start,
      timeEnd: end,
      tags: Set<int>.from(tags.map((el) => el as int)), 
      likes: json['likes'], 
      created: DateTime.parse(json['created']), 
      updated: DateTime.parse(json['updated']), 
      status: Status.values.firstWhere((element) => element.name == json['status']),
      );
  }
  

}