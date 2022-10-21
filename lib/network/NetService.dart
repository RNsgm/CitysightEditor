import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:citysight_editor/dto/ContentDto.dart';
import 'package:citysight_editor/dto/Criterion.dart';
import 'package:citysight_editor/dto/ImageMeta.dart';
import 'package:citysight_editor/dto/Tag.dart';
import 'package:citysight_editor/enums/ContentType.dart';
import 'package:citysight_editor/enums/Status.dart';
import 'package:citysight_editor/utils/SystemPrefs.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

var logger = Logger();
SystemPrefs _prefs = SystemPrefs();

// String baseContentUrl = "https://citysight.ru";
String baseContentUrl = "http://localhost:8080";

Future<bool> isAdmin() async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/user/is_admin'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['value'];
  } else if(response.statusCode == 400) {
    return false;
  } else {
    return false;
  }
}
Future<bool> isEditor() async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/user/is_editor'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['value'];
  } else if(response.statusCode == 400) {
    return false;
  } else {
    return false;
  }
}
Future<bool> isModerator() async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/user/is_Moderator'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['value'];
  } else if(response.statusCode == 400) {
    return false;
  } else {
    return false;
  }
}
//http://localhost:8080/api/v1/images/name?id=
Future<List<ContentDto>> getAllowedContent(int page) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/content/show/full/page/$page'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  // logger.d(jsonDecode(response.body));
  if (response.statusCode == 200) {
    Iterable contents = jsonDecode(utf8.decode(response.bodyBytes));
    return List<ContentDto>.from(contents.map((e) => ContentDto.fromJson(e)));
  } else if(response.statusCode == 400) {
    return List<ContentDto>.empty();
  } else {
    return List<ContentDto>.empty();
  }
}
Future<ImageMeta> getImageName(String name) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/images/name?id=$name'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    return ImageMeta.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else if(response.statusCode == 400) {
    return ImageMeta(id: "", name: "");
  } else {
    return ImageMeta(id: "", name: "");
  }
}
Future<ImageMeta> uploadImage(Uint8List s, Uint8List r, String name, String source) async {

  final request = http.MultipartRequest("POST", Uri.parse('$baseContentUrl/api/v1/images/upload'));
  request.headers["Authorization"] = await _prefs.getAuthToken();
  request.fields["image_name"] = name;
  request.fields["image_source"] = source;

  final square = http.MultipartFile.fromBytes("image_s", s, contentType: MediaType.parse('multipart/form-data'), filename: 'file.jpg');
  final rectangle = http.MultipartFile.fromBytes("image_r", r, contentType: MediaType.parse('multipart/form-data'), filename: 'file.jpg');

  request.files.add(square);
  request.files.add(rectangle);

  final response = await request.send();
  final responseBytes = await response.stream.toBytes();

  if (response.statusCode == 200) {
    return ImageMeta.fromJson(jsonDecode(utf8.decode(responseBytes)));
  } else if(response.statusCode == 400) {
    return ImageMeta(id: "", name: "Error");
  } else {
    return ImageMeta(id: "", name: "Error");
  }
}
Future<bool> saveContent(
  int id, 
  ContentType type, 
  String title, 
  String image, 
  List data,
  Map<String, dynamic> geojson,
  int criteria,
  List<int> tags,
  String timeStart,
  String timeEnd
) async {
  var param = FormData.fromMap({
    "id": id,
    "type": type.name,
    "title": title,
    "image": image,
    "data": json.encode(data),
    "geojson": json.encode(geojson),
    "criteria": criteria,
    "tags": tags,
    "time_start": timeStart,
    "time_end": timeEnd
  });
  // var jsons = json.encode(param);
  var dio = Dio();
  dio.options.headers['cache-control'] = 'no-cache';
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['authorization'] = await _prefs.getAuthToken();
  final response = await dio.post(
      '$baseContentUrl/api/v1/content/save',
      data: param
    );
  if (response.statusCode == 200) {
    return true;
  } else if(response.statusCode == 400) {
    return false;
  } else {
    return false;
  }
}
Future<List<ContentDto>> getContentByQuery(int page, String query) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/content/search/all/$query/$page'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    Iterable contents = jsonDecode(utf8.decode(response.bodyBytes));
    return List<ContentDto>.from(contents.map((e) => ContentDto.fromJson(e)));
  } else if(response.statusCode == 400) {
    return List<ContentDto>.empty();
  } else {
    return List<ContentDto>.empty();
  }
}
Future<List<ContentDto>> getContentByQueryAndByType(int page, ContentType type, String query) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/content/search/all/${type.name}/$query/$page'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    Iterable contents = jsonDecode(utf8.decode(response.bodyBytes));
    return List<ContentDto>.from(contents.map((e) => ContentDto.fromJson(e)));
  } else if(response.statusCode == 400) {
    return List<ContentDto>.empty();
  } else {
    return List<ContentDto>.empty();
  }
}
Future<ContentDto?> getContentByID(int id) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/content/get/$id'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    return ContentDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else if(response.statusCode == 400) {
    return null;
  } else {
    return null;
  }
}
Future<List<Criterion>> getCriterionByType(ContentType type) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/values/criterions'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
      body: <String, String>{
        "type": type.name
      }
    );
  if (response.statusCode == 200) {
    Iterable criterions = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Criterion>.from(criterions.map((e) => Criterion.fromJson(e)));
  } else if(response.statusCode == 400) {
    return [];
  } else {
    return [];
  }
}
Future<List<Tag>> getTagForCriteria(int id) async {
  final response = await http.post(
      Uri.parse('$baseContentUrl/api/v1/values/tag/${id}'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': await _prefs.getAuthToken()
      },
    );
  if (response.statusCode == 200) {
    Iterable tags = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Tag>.from(tags.map((e) => Tag.fromJson(e)));
  } else if(response.statusCode == 400) {
    return [];
  } else {
    return [];
  }
}

class Auth{
  final String? username;
  final String? token;

  Auth({this.username, this.token}) : super();

  factory Auth.fromJson(Map<String, dynamic> json){
    return Auth(
      username: json['username'],
      token: json['token']
    );
  }
}