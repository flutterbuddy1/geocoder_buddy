// Map Data Model
import 'dart:convert';

List<MapData> mapDataFromJson(String str) =>
    List<MapData>.from(json.decode(str).map((x) => MapData.fromJson(x)));

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
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        placeRank: json["place_rank"],
        importance: json["importance"].toDouble(),
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
