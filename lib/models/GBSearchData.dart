import 'dart:convert';

List<GBSearchData> bgSearchDataFromJson(String str) => List<GBSearchData>.from(
    json.decode(str).map((x) => GBSearchData.fromJson(x)));

String bgSearchDataToJson(List<GBSearchData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GBSearchData {
  GBSearchData({
    required this.placeId,
    required this.id,
    required this.boundingbox,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.placeRank,
    required this.importance,
  });

  int placeId;
  int id;
  List<String> boundingbox;
  String lat;
  String lon;
  String displayName;
  int placeRank;
  double importance;

  factory GBSearchData.fromJson(Map<String, dynamic> json) => GBSearchData(
        placeId: json["place_id"],
        id: json["osm_id"],
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        placeRank: json["place_rank"],
        importance: json["importance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "osm_id": id,
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "place_rank": placeRank,
        "importance": importance,
      };
}
