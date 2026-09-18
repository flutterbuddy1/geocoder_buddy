import 'package:geocoder_buddy/src/models/GBData.dart';
import 'package:geocoder_buddy/src/models/GBLatLng.dart';
import 'package:geocoder_buddy/src/models/GeocoderException.dart';
import 'package:geocoder_buddy/src/models/MapData.dart';
import 'package:http/http.dart' as http;

const String nominatimHost = "nominatim.openstreetmap.org";

class NetworkService {
  /// Default User-Agent sent with requests to comply with Nominatim usage policy.
  static String userAgent =
      'GeocoderBuddy/1.0.2 (Flutter; https://github.com/flutterbuddy1/geocoder_buddy)';

  /// Searches for places matching the [query].
  /// Optionally specify [language] (e.g. 'en', 'ar', 'fr') for localized results.
  static Future<List<MapData>> searchAddress(
    String query, {
    String? language,
  }) async {
    final queryParams = <String, String>{
      'q': query,
      'format': 'jsonv2',
    };
    if (language != null && language.trim().isNotEmpty) {
      queryParams['accept-language'] = language.trim();
    }

    final uri = Uri.https(nominatimHost, '/search', queryParams);
    final headers = <String, String>{
      'User-Agent': userAgent,
      'Accept': 'application/json',
      if (language != null && language.trim().isNotEmpty)
        'Accept-Language': language.trim(),
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return mapDataFromJson(response.body);
    } else {
      throw GeocoderException(
        'Search request failed: ${response.reasonPhrase ?? "HTTP Error"}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Backwards-compatible alias for [searchAddress].
  @Deprecated('Use searchAddress instead')
  static Future<List<MapData>> searhAddress(
    String query, {
    String? language,
  }) =>
      searchAddress(query, language: language);

  /// Retrieves geocoding details for the given [pos] coordinates.
  /// Optionally specify [language] (e.g. 'en', 'ar', 'fr') for localized results.
  static Future<GBData> getDetails(
    GBLatLng pos, {
    String? language,
  }) async {
    final queryParams = <String, String>{
      'lat': pos.lat.toString(),
      'lon': pos.lng.toString(),
      'format': 'jsonv2',
    };
    if (language != null && language.trim().isNotEmpty) {
      queryParams['accept-language'] = language.trim();
    }

    final uri = Uri.https(nominatimHost, '/reverse', queryParams);
    final headers = <String, String>{
      'User-Agent': userAgent,
      'Accept': 'application/json',
      if (language != null && language.trim().isNotEmpty)
        'Accept-Language': language.trim(),
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return gbDataFromJson(response.body);
    } else {
      throw GeocoderException(
        'Reverse geocoding request failed: ${response.reasonPhrase ?? "HTTP Error"}',
        statusCode: response.statusCode,
      );
    }
  }
}
