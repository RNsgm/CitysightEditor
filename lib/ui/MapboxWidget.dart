import 'dart:io';
import 'dart:js_util';
import 'dart:math';

import 'package:citysight_editor/controllers/MapboxDataController.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'; // ignore: unnecessary_import
import 'package:mapbox_gl/mapbox_gl.dart';


class MapboxWidget extends StatefulWidget {
  MapboxWidget({required this.controller});

  MapboxDataController controller;

  @override
  State<StatefulWidget> createState() => MapboxWidgetState();
}

class MapboxWidgetState extends State<MapboxWidget> {
  MapboxWidgetState();

  MapboxMapController? controller;
  int _symbolCount = 0;
  Symbol? _selectedSymbol;
  bool _iconAllowOverlap = false;
  
  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onStyleLoaded() {
    addImageFromAsset("pin", "images/marker.png");
    _addFromController();
  }

  @override
  void dispose() {
    controller?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedSymbol(
        const SymbolOptions(iconSize: 0.08),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedSymbol(
      const SymbolOptions(
        iconSize: 0.09,
      ),
    );
  }

  void _updateSelectedSymbol(SymbolOptions changes) async {
    await controller!.updateSymbol(_selectedSymbol!, changes);
  }

  void _add(point, coordinate) {

    if (_selectedSymbol != null) {
      _updateSelectedSymbol(
        const SymbolOptions(iconSize: 0.08),
      );
    }

    List<int> availableNumbers = Iterable<int>.generate(12).toList();
    controller!.symbols.forEach(
        (s) => availableNumbers.removeWhere((i) => i == s.data!['count']));
    if (availableNumbers.isNotEmpty) {
      controller!.addSymbol(
          _getSymbolOptions(LatLng(coordinate.latitude, coordinate.longitude)),
          {'count': availableNumbers.first});
      setState(() {
        _selectedSymbol = null;
        _symbolCount += 1;
      });
    }
  }

  SymbolOptions _getSymbolOptions(LatLng geometry) {
    return SymbolOptions(
      iconImage: "pin",
      iconSize: 0.08,
      iconAnchor: "bottom",
      geometry: geometry,
    );
  }

  void _remove() {
    controller!.removeSymbol(_selectedSymbol!);
    setState(() {
      _selectedSymbol = null;
      _symbolCount -= 1;
    });
  }

  void _removeAll() {
    controller!.removeSymbols(controller!.symbols);
    setState(() {
      _selectedSymbol = null;
      _symbolCount = 0;
    });
  }

  void _getLatLng() async {
    LatLng latLng = await controller!.getSymbolLatLng(_selectedSymbol!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(latLng.toString()),
      ),
    );
  }

  @override
  void initState() {
    widget.controller.addListener(_addFromController);
    super.initState();
  }

  void _addFromController(){
    List<Map> features = widget.controller.getFeatures();
    // logger.wtf(features);
    features.forEach((feature) {
      bool isNotFind = true;
      controller!.symbols.forEach((symbol){
        if(feature["id"] == symbol.id) {
          isNotFind = false;
        }
      });

      if(isNotFind){
        Map<String, dynamic> geometry = feature["geometry"];
        Iterable coordIter = geometry["coordinates"];
        List<double> coordinates = coordIter.map<double>((e) => e).toList();
        _add(null, LatLng(coordinates[1], coordinates[0]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(controller != null) {
      widget.controller.addSymbols(controller!.symbols);
    }
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.lime.shade100,
                child: ElevatedButton(onPressed: (){_remove();}, child: Icon(Icons.delete),),
              )
            ],
          )
        ),
        Expanded(
          flex: 1,
          child: MapboxMap(
            styleString: "mapbox://styles/nojed/ckflop5w82w7o19o17asac6er",
            accessToken: const String.fromEnvironment("ACCESS_TOKEN"),
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            onMapClick: (point, coordinates) => _add(point, coordinates),
            initialCameraPosition: const CameraPosition(
              target: LatLng(55.752, 37.624),
              zoom: 14.43,
            ),
          ),
        )
      ],
    );
  }
}