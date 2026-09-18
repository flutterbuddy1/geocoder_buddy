// Map Data Model
import 'dart:convert';
import 'package:geocoder_buddy/src/models/GeocoderException.dart';

List<MapData> mapDataFromJson(String str) {
  final decoded = json.decode(str);
  if (decoded is List) {
    return List<MapData>.from(
      decoded.whereType<Map<String, dynamic>>().map(
            (x) => MapData.fromJson(x),
          ),
    );
  }
  if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
    throw GeocoderException(decoded['error']?.toString() ?? 'Unable to geocode');
  }
  return <MapData>[];
}

String mapDataToJson(List<MapData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MapData {
  MapData({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.boundingbox,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.placeRank,
    required this.importance,
  });

  int placeId;
  String licence;
  String osmType;
  int osmId;
  List<String> boundingbox;
  String lat;
  String lon;
  String displayName;
  int placeRank;
  double importance;

  factory MapData.fromJson(Map<String, dynamic> json) => MapData(
        placeId: (json["place_id"] is num)
            ? (json["place_id"] as num).toInt()
            : int.tryParse(json["place_id"]?.toString() ?? "") ?? 0,
        licence: json["licence"]?.toString() ?? "",
        osmType: json["osm_type"]?.toString() ?? "",
        osmId: (json["osm_id"] is num)
            ? (json["osm_id"] as num).toInt()
            : int.tryParse(json["osm_id"]?.toString() ?? "") ?? 0,
        boundingbox: json["boundingbox"] is List
            ? List<String>.from(
                (json["boundingbox"] as List).map((x) => x?.toString() ?? ""))
            : <String>[],
        lat: json["lat"]?.toString() ?? "",
        lon: json["lon"]?.toString() ?? "",
        displayName: json["display_name"]?.toString() ?? "",
        placeRank: (json["place_rank"] is num)
            ? (json["place_rank"] as num).toInt()
            : int.tryParse(json["place_rank"]?.toString() ?? "") ?? 0,
        importance: (json["importance"] is num)
            ? (json["importance"] as num).toDouble()
            : double.tryParse(json["importance"]?.toString() ?? "") ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "place_rank": placeRank,
        "importance": importance,
      };
}
