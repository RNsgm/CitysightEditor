import 'dart:typed_data';

import 'package:citysight_editor/pages/Login.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/utils/modalBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:citysight_editor/dto/Markers.dart';
import 'package:turf/helpers.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MapFragment extends StatefulWidget {
  MapFragment({Key? key}) : super(key: key);

  @override
  State<MapFragment> createState() => _MapFragmentState();
}

class GeopointOnMap{
  GeopointOnMap({required this.id, required this.criteria, required this.geojson});

  int id;
  int criteria;
  FeatureCollection geojson;

  factory GeopointOnMap.fromJson(Map<String, dynamic> json){
    List<Feature> features = [];

    if(json['geodata'] != ""){
      Map<String, dynamic> geoJson = jsonDecode(json['geodata']);
      Iterable markers = geoJson['markers'];
      for (var element in markers) {
        try {
          features.add(Feature(
            id: json['id'],
            geometry: Point(
              coordinates: Position(element['lat'], element['lng']),
            ),
          ));
        } catch (e) {}
      }
    }

    return GeopointOnMap(
      id: json['id'], 
      criteria: json['criteria'], 
      geojson: FeatureCollection(features: features)
    );
  }
}

class _MapFragmentState extends State<MapFragment> {

  MapboxMapController? controller;
  int _symbolCount = 0;
  Symbol? _selectedSymbol;
  bool _iconAllowOverlap = false;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
    controller.onCircleTapped.add(_onCircleTapped);
  }

  Map<int, String> colors = {
    3:'#30B9FE',
    4:'#26CAAF',
    5:'#FE3052',
    6:'#7530FE',
    7:'#DC30FE',
    8:'#4357AD',
    9:'#93CA26',
    10:'#3052FE',
    11:'#FBAF00'
  };

  Map<int, String> icons = {
    3:'music',
    4:'relax',
    5:'meal',
    6:'art',
    7:'events',
    8:'sport',
    9:'nature',
    10:'university',
    11:'special'
  };

  // val CRITERIA_MUSIC = 3
  //       val CRITERIA_RELAX = 4
  //       val CRITERIA_MEAL = 5
  //       val CRITERIA_ART = 6
  //       val CRITERIA_ENTERTAINMENT = 7
  //       val CRITERIA_SPORT = 8
  //       val CRITERIA_NATURE = 9
  //       val CRITERIA_EDUCATION = 10
  //       val CRITERIA_INTERESTING = 11

  void _onStyleLoaded() {
    addImageFromAsset("art", "images/art.png");
    addImageFromAsset("meal", "images/meal.png");
    addImageFromAsset("special", "images/special.png");
    addImageFromAsset("sport", "images/sport.png");
    addImageFromAsset("relax", "images/relax.png");
    addImageFromAsset("nature", "images/nature.png");
    addImageFromAsset("music", "images/music.png");
    addImageFromAsset("events", "images/events.png");
    addImageFromAsset("university", "images/university.png");
    // controller!.addGeoJsonSource(sourceId, geojson)
    try{
      // controller!.addCircleLayer("entertainment-source", "entertainment-circle", const CircleLayerProperties(circleRadius: 7.0, circleColor: ""));
      // controller!.addCircleLayer("nature-source", "nature-circle", const CircleLayerProperties(circleRadius: 7.0, circleColor: ""));
    }catch(e){print(e);}
    // addImageFromUrl("networkImage", Uri.parse("https://via.placeholder.com/50"));
    getMarkers().then((value) => {
      value.forEach((element) {
        controller!.addGeoJsonSource("source-${element.id}", element.geojson.toJson());
        controller!.addCircleLayer("source-${element.id}", "circle-${element.id}", CircleLayerProperties(circleRadius: 15.0, circleColor: colors[element.criteria]));
        controller!.addSymbolLayer("source-${element.id}", "symbol-${element.id}", SymbolLayerProperties(iconTranslate: [0.5,0], iconImage: icons[element.criteria]));
      })
    });
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return controller!.addImage(name, response.bodyBytes);
  }

  Future<List<GeopointOnMap>> getMarkers() async{
    try {
      final response = await http.post(
        Uri.parse('$baseContentUrl/api/v1/content/all/geopoint'),
      );
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);
        List<GeopointOnMap> result = List<GeopointOnMap>.from(list.map((el) => GeopointOnMap.fromJson(el)));
        return result;
      } else {
        return [];
      }
    } catch (e) {
      showModalWithIcon(context, Icons.signal_cellular_connected_no_internet_4_bar, 'Ошибка соединения');
      return [];
    }
  }

  void _onSymbolTapped(Symbol symbol) {
    print(symbol.id);
  }
  void _onCircleTapped(Circle circle) {
    print(circle.id);
  }

  void _add(LatLng latLng){
    controller!.addCircle(CircleOptions(
      geometry: latLng,
      circleRadius: 10.0,
      circleColor: "#152573",
      draggable: true
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
          styleString: "mapbox://styles/nojed/ckflop5w82w7o19o17asac6er",
          accessToken: const String.fromEnvironment("ACCESS_TOKEN"),
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoaded,
          trackCameraPosition: true,
          initialCameraPosition: const CameraPosition(
              target: LatLng(55.752, 37.624),
              zoom: 14.43,
          ),
          onMapClick: (point, coordinate) {
            // _add(coordinate);
          },
        );
  }
}