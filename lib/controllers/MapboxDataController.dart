import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxDataController extends ChangeNotifier{
  List<Map> _features = [];

  void add(Map<String, dynamic> data){
    try{
      Iterable markers = data["markers"];
      markers.forEach((marker) {
        _features.add(Symbol(Iterable<int>.generate(12).toString(), _getSymbolOptions(LatLng(marker["lng"], marker["lat"]))).toGeoJson());
      });
      notifyListeners();
    }catch(e){
      print("Geo load error: $e");
    }
  }
  void addSymbols(Set<Symbol> symbols){
    _features = [];
    symbols.forEach((e) => _features.add(e.toGeoJson()));

    notifyListeners();
  }
  List<Map> getFeatures() => _features;

  Map<String, dynamic> getData(){
    var data = {
      "markers":[],
      "itinerary":[],
      "property":{
        "places":[]
      }
    };

    List<dynamic> markers = [];
    _features.forEach((feature) {
      Map<String, dynamic> geometry = feature["geometry"];
      if(geometry["type"] == "Point"){
        Iterable coordIter = geometry["coordinates"];
        List<double> coordinates = coordIter.map<double>((e) => e).toList();
        markers.add({"lat":coordinates[0], "lng":coordinates[1]});
      }
    });
    data["markers"] = markers;

    return data;
  }

  SymbolOptions _getSymbolOptions(LatLng geometry) {
    return SymbolOptions(
      iconImage: "pin",
      iconSize: 0.08,
      iconAnchor: "bottom",
      geometry: geometry,
    );
  }

  void clear(){
  _features = [];
  notifyListeners();
  }

}