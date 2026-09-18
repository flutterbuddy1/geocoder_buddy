import 'package:flutter_test/flutter_test.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:geocoder_buddy/src/models/MapData.dart';

void main() {
  group('GBData and Address deserialization (Fixes #1, #3, #6)', () {
    test('parses full Nominatim reverse geocode JSON successfully', () {
      const jsonStr = '''{
        "place_id": 45700845,
        "licence": "Data © OpenStreetMap contributors",
        "osm_type": "way",
        "osm_id": 95085362,
        "lat": "25.2047774",
        "lon": "55.2707874",
        "place_rank": 26,
        "importance": 0.053407,
        "display_name": "Financial Centre Road, Downtown Dubai, Dubai, UAE",
        "address": {
          "road": "Financial Centre Road",
          "house_number": "12B",
          "suburb": "Burj Khalifa",
          "city": "Dubai",
          "state": "Dubai",
          "ISO3166-2-lvl4": "AE-DU",
          "country": "United Arab Emirates",
          "country_code": "ae"
        },
        "boundingbox": ["25.2036539", "25.2053007", "55.2698350", "55.2728567"]
      }''';

      final data = gbDataFromJson(jsonStr);

      expect(data.placeId, equals(45700845));
      expect(data.osmType, equals('way'));
      expect(data.id, equals(95085362));
      expect(data.lat, equals('25.2047774'));
      expect(data.lon, equals('55.2707874'));
      expect(data.placeRank, equals(26));
      expect(data.importance, closeTo(0.053407, 0.0001));
      expect(data.displayName, contains('Financial Centre Road'));
      expect(data.boundingbox.length, equals(4));

      // Address verification
      expect(data.address.road, equals('Financial Centre Road'));
      expect(data.address.houseNumber, equals('12B'));
      expect(data.address.suburb, equals('Burj Khalifa'));
      expect(data.address.city, equals('Dubai'));
      expect(data.address.village, isEmpty);
      expect(data.address.county, isEmpty);
      expect(data.address.country, equals('United Arab Emirates'));
      expect(data.address.countryCode, equals('ae'));
      expect(data.address.rawAddress.containsKey('suburb'), isTrue);
    });

    test('handles missing or null address fields gracefully without throwing', () {
      final jsonMap = <String, dynamic>{
        "place_id": 12345,
        "osm_type": "node",
        "osm_id": 67890,
        "lat": "10.0",
        "lon": "20.0",
        "place_rank": null,
        "importance": null,
        "display_name": null,
        "address": null,
        "boundingbox": null,
      };

      final data = GBData.fromJson(jsonMap);

      expect(data.placeId, equals(12345));
      expect(data.osmType, equals('node'));
      expect(data.id, equals(67890));
      expect(data.placeRank, equals(0));
      expect(data.importance, equals(0.0));
      expect(data.displayName, isEmpty);
      expect(data.boundingbox, isEmpty);
      expect(data.address.road, isEmpty);
      expect(data.address.city, isEmpty);
    });

    test('maps house_number from snake_case and camelCase', () {
      final addr1 = Address.fromJson({'house_number': '42'});
      expect(addr1.houseNumber, equals('42'));

      final addr2 = Address.fromJson({'houseNumber': '99'});
      expect(addr2.houseNumber, equals('99'));
    });

    test('maps additional address fields (suburb, town, neighbourhood, etc.)', () {
      final addr = Address.fromJson({
        'road': 'Baker Street',
        'suburb': 'Marylebone',
        'neighbourhood': 'West End',
        'quarter': 'City of Westminster',
        'town': 'London Town',
        'city_district': 'Central',
      });

      expect(addr.road, equals('Baker Street'));
      expect(addr.suburb, equals('Marylebone'));
      expect(addr.neighbourhood, equals('West End'));
      expect(addr.quarter, equals('City of Westminster'));
      expect(addr.town, equals('London Town'));
      expect(addr.cityDistrict, equals('Central'));
    });

    test('throws GeocoderException on Nominatim error response (Fixes #3)', () {
      const errorJson = '{"error": "Unable to geocode"}';

      expect(
        () => gbDataFromJson(errorJson),
        throwsA(
          isA<GeocoderException>().having(
            (e) => e.message,
            'message',
            contains('Unable to geocode'),
          ),
        ),
      );
    });
  });

  group('GBSearchData and MapData deserialization', () {
    test('parses list of GBSearchData safely', () {
      const jsonListStr = '''[
        {
          "place_id": 101,
          "osm_id": 202,
          "boundingbox": ["10", "11", "20", "21"],
          "lat": "10.5",
          "lon": "20.5",
          "display_name": "Sample Location",
          "place_rank": 15,
          "importance": 0.45
        }
      ]''';

      final results = bgSearchDataFromJson(jsonListStr);
      expect(results.length, equals(1));
      expect(results.first.placeId, equals(101));
      expect(results.first.id, equals(202));
      expect(results.first.lat, equals('10.5'));
      expect(results.first.lon, equals('20.5'));
      expect(results.first.displayName, equals('Sample Location'));
      expect(results.first.importance, closeTo(0.45, 0.001));
    });

    test('handles nulls in MapData without throwing', () {
      final mapData = MapData.fromJson({
        "place_id": null,
        "licence": null,
        "osm_type": null,
        "osm_id": null,
        "boundingbox": null,
        "lat": null,
        "lon": null,
        "display_name": null,
        "place_rank": null,
        "importance": null,
      });

      expect(mapData.placeId, equals(0));
      expect(mapData.licence, isEmpty);
      expect(mapData.lat, isEmpty);
      expect(mapData.lon, isEmpty);
      expect(mapData.displayName, isEmpty);
      expect(mapData.importance, equals(0.0));
      expect(mapData.boundingbox, isEmpty);
    });

    test('bgSearchDataFromJson throws GeocoderException on error map', () {
      const errorStr = '{"error": "Search rate limit exceeded"}';
      expect(
        () => bgSearchDataFromJson(errorStr),
        throwsA(isA<GeocoderException>()),
      );
    });
  });

  group('UserAgent and configuration (Fixes #5)', () {
    test('default userAgent is present and complies with policy', () {
      expect(GeocoderBuddy.userAgent, isNotEmpty);
      expect(GeocoderBuddy.userAgent, contains('GeocoderBuddy'));
    });

    test('custom userAgent can be configured', () {
      final original = GeocoderBuddy.userAgent;
      try {
        GeocoderBuddy.userAgent = 'MyCustomApp/1.0 (contact@example.com)';
        expect(GeocoderBuddy.userAgent,
            equals('MyCustomApp/1.0 (contact@example.com)'));
      } finally {
        GeocoderBuddy.userAgent = original;
      }
    });
  });

  group('GBLatLng', () {
    test('instantiates with lat and lng', () {
      final pos = GBLatLng(lat: 37.7749, lng: -122.4194);
      expect(pos.lat, equals(37.7749));
      expect(pos.lng, equals(-122.4194));
    });
  });

  group('GeocoderException formatting', () {
    test('formats with and without status code', () {
      final ex1 = GeocoderException('Something went wrong');
      expect(ex1.toString(), equals('GeocoderException: Something went wrong'));

      final ex2 = GeocoderException('Forbidden', statusCode: 403);
      expect(ex2.toString(),
          equals('GeocoderException: Forbidden (status code: 403)'));
    });
  });
}
