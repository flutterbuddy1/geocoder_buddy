import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:geocoder_buddy/src/models/MapData.dart';
import 'package:geocoder_buddy/src/services/NetworkService.dart';

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
