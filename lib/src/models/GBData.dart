// Geocoder Buddy Data Model
import 'dart:convert';
import 'package:geocoder_buddy/src/models/GeocoderException.dart';

GBData gbDataFromJson(String str) {
  final decoded = json.decode(str);
  if (decoded is Map<String, dynamic>) {
    if (decoded.containsKey('error')) {
      throw GeocoderException(
          decoded['error']?.toString() ?? 'Unable to geocode');
    }
    return GBData.fromJson(decoded);
  }
  throw GeocoderException('Invalid response from geocoder service');
}

String gbDataToJson(GBData data) => json.encode(data.toJson());

class GBData {
  GBData({
    required this.placeId,
    required this.osmType,
    required this.id,
    required this.lat,
    required this.lon,
    required this.placeRank,
    required this.importance,
    required this.displayName,
    required this.address,
    required this.boundingbox,
    this.raw = const {},
  });

  int placeId;
  String osmType;
  int id;
  String lat;
  String lon;
  int placeRank;
  double importance;
  String displayName;
  Address address;
  List<String> boundingbox;
  Map<String, dynamic> raw;

  factory GBData.fromJson(Map<String, dynamic> json) => GBData(
        placeId: (json["place_id"] is num)
            ? (json["place_id"] as num).toInt()
            : int.tryParse(json["place_id"]?.toString() ?? "") ?? 0,
        osmType: json["osm_type"]?.toString() ?? "",
        id: (json["osm_id"] is num)
            ? (json["osm_id"] as num).toInt()
            : int.tryParse(json["osm_id"]?.toString() ?? "") ?? 0,
        lat: json["lat"]?.toString() ?? "",
        lon: json["lon"]?.toString() ?? "",
        placeRank: (json["place_rank"] is num)
            ? (json["place_rank"] as num).toInt()
            : int.tryParse(json["place_rank"]?.toString() ?? "") ?? 0,
        importance: (json["importance"] is num)
            ? (json["importance"] as num).toDouble()
            : double.tryParse(json["importance"]?.toString() ?? "") ?? 0.0,
        displayName: json["display_name"]?.toString() ?? "",
        address: json["address"] is Map<String, dynamic>
            ? Address.fromJson(json["address"] as Map<String, dynamic>)
            : Address.empty(),
        boundingbox: json["boundingbox"] is List
            ? List<String>.from(
                (json["boundingbox"] as List).map((x) => x?.toString() ?? ""))
            : <String>[],
        raw: Map<String, dynamic>.from(json),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "osm_type": osmType,
        "osm_id": id,
        "lat": lat,
        "lon": lon,
        "place_rank": placeRank,
        "importance": importance,
        "display_name": displayName,
        "address": address.toJson(),
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
      };
}

class Address {
  Address({
    this.road = "",
    this.houseNumber = "",
    this.village = "",
    this.city = "",
    this.municipality = "",
    this.county = "",
    this.stateDistrict = "",
    this.state = "",
    this.iso31662Lvl4 = "",
    this.postcode = "",
    this.country = "",
    this.countryCode = "",
    this.suburb = "",
    this.neighbourhood = "",
    this.quarter = "",
    this.hamlet = "",
    this.town = "",
    this.cityDistrict = "",
    this.rawAddress = const {},
  });

  factory Address.empty() => Address();

  String road;
  String houseNumber;
  String village;
  String city;
  String municipality;
  String county;
  String stateDistrict;
  String state;
  String iso31662Lvl4;
  String postcode;
  String country;
  String countryCode;
  String suburb;
  String neighbourhood;
  String quarter;
  String hamlet;
  String town;
  String cityDistrict;
  Map<String, dynamic> rawAddress;

  factory Address.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Address.empty();
    return Address(
      road: json["road"]?.toString() ?? "",
      houseNumber: json["house_number"]?.toString() ??
          json["houseNumber"]?.toString() ??
          "",
      village: json["village"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      municipality: json["municipality"]?.toString() ?? "",
      county: json["county"]?.toString() ?? "",
      stateDistrict: json["state_district"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      iso31662Lvl4: json["ISO3166-2-lvl4"]?.toString() ?? "",
      postcode: json["postcode"]?.toString() ?? "",
      country: json["country"]?.toString() ?? "",
      countryCode: json["country_code"]?.toString() ?? "",
      suburb: json["suburb"]?.toString() ?? "",
      neighbourhood: json["neighbourhood"]?.toString() ?? "",
      quarter: json["quarter"]?.toString() ?? "",
      hamlet: json["hamlet"]?.toString() ?? "",
      town: json["town"]?.toString() ?? "",
      cityDistrict: json["city_district"]?.toString() ?? "",
      rawAddress: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => {
        "road": road,
        "houseNumber": houseNumber,
        "village": village,
        "city": city,
        "municipality": municipality,
        "county": county,
        "state_district": stateDistrict,
        "state": state,
        "ISO3166-2-lvl4": iso31662Lvl4,
        "postcode": postcode,
        "country": country,
        "country_code": countryCode,
        if (suburb.isNotEmpty) "suburb": suburb,
        if (neighbourhood.isNotEmpty) "neighbourhood": neighbourhood,
        if (quarter.isNotEmpty) "quarter": quarter,
        if (hamlet.isNotEmpty) "hamlet": hamlet,
        if (town.isNotEmpty) "town": town,
        if (cityDistrict.isNotEmpty) "city_district": cityDistrict,
      };
}
