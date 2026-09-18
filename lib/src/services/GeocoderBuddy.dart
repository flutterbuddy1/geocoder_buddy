import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:geocoder_buddy/src/models/MapData.dart';
import 'package:geocoder_buddy/src/services/NetworkService.dart';

class GeocoderBuddy {
  /// Custom User-Agent header string sent with all requests.
  /// Defaults to a compliant user-agent identifying GeocoderBuddy.
  static String get userAgent => NetworkService.userAgent;
  static set userAgent(String value) => NetworkService.userAgent = value;

  /// Searches for places matching the given [address].
  /// Optionally specify [language] (e.g. 'en', 'ar', 'fr', 'es') for localized names.
  static Future<List<GBSearchData>> query(
    String address, {
    String? language,
  }) async {
    var data = await NetworkService.searchAddress(address, language: language);
    return bgSearchDataFromJson(mapDataToJson(data));
  }

  /// Converts a [GBSearchData] result into full [GBData] reverse geocoding details.
  /// Optionally specify [language] for localized results.
  static Future<GBData> searchToGBData(
    GBSearchData data, {
    String? language,
  }) async {
    var pos = GBLatLng(
      lat: double.tryParse(data.lat) ?? 0.0,
      lng: double.tryParse(data.lon) ?? 0.0,
    );
    return await NetworkService.getDetails(pos, language: language);
  }

  /// Finds reverse geocoding details for a given [pos] (latitude/longitude).
  /// Optionally specify [language] for localized results.
  static Future<GBData> findDetails(
    GBLatLng pos, {
    String? language,
  }) async {
    return await NetworkService.getDetails(pos, language: language);
  }
}
