import 'package:geocoder_buddy/src/models/GBData.dart';
import 'package:geocoder_buddy/src/models/GBLatLng.dart';
import 'package:geocoder_buddy/src/models/MapData.dart';
import 'package:http/http.dart' as http;

const PATH = "https://nominatim.openstreetmap.org";

class NetworkService {
  static Future<List<MapData>> searhAddress(String query) async {
    var request =
        http.Request('GET', Uri.parse("$PATH/search?q=$query&format=jsonv2"));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return mapDataFromJson(data);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<GBData> getDetails(GBLatLng pos) async {
    var request = http.Request('GET',
        Uri.parse('$PATH/reverse?lat=${pos.lat}&lon=${pos.lng}&format=jsonv2'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return gbDataFromJson(data);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
