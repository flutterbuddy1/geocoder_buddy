import 'dart:convert';
import 'package:geocoder_buddy/src/models/GeocoderException.dart';

List<GBSearchData> bgSearchDataFromJson(String str) {
  final decoded = json.decode(str);
  if (decoded is List) {
    return List<GBSearchData>.from(
      decoded.whereType<Map<String, dynamic>>().map(
            (x) => GBSearchData.fromJson(x),
          ),
    );
  }
  if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
    throw GeocoderException(decoded['error']?.toString() ?? 'Unable to geocode');
  }
  return <GBSearchData>[];
}

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
        placeId: (json["place_id"] is num)
            ? (json["place_id"] as num).toInt()
            : int.tryParse(json["place_id"]?.toString() ?? "") ?? 0,
        id: (json["osm_id"] is num)
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
        "osm_id": id,
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "place_rank": placeRank,
        "importance": importance,
      };
}
