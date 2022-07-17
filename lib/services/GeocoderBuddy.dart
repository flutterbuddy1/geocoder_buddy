import 'package:geocoder_buddy/models/GBData.dart';
import 'package:geocoder_buddy/models/GBLatLng.dart';
import 'package:geocoder_buddy/models/GBSearchData.dart';
import 'package:geocoder_buddy/models/MapData.dart';
import 'package:geocoder_buddy/services/NetworkService.dart';

class GeocoderBuddy {
  static Future<List<GBSearchData>> query(String address) async {
    var data = await NetworkService.searhAddress(address);
    return bgSearchDataFromJson(mapDataToJson(data));
  }

  static Future<GBData> searchToGBData(GBSearchData data) async {
    var pos =
        GBLatLng(lat: double.parse(data.lat), lng: double.parse(data.lon));
    var res = await NetworkService.getDetails(pos);
    return res;
  }

  static Future<GBData> findDetails(GBLatLng pos) async {
    var data = await NetworkService.getDetails(pos);
    return data;
  }
}
