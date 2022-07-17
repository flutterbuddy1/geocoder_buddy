![](https://raw.githubusercontent.com/flutterbuddy1/geocoder_buddy/main/banner.png)

# Features
* Easy To Use
* Fast & Secure
* No Api Key Required
* More Detailed Data
* Search Locations Without Api Key

# Getting Started

Run This Command in Terminal or Install in Your Way
```yaml
flutter pub get geocoder_buddy
```

# Searching Location
```dart
// GBSearchData Class Porvided By geocoder_buddy
List<GBSearchData> data = await GeocoderBuddy.query(query);
```
## GBSearchData Class
```dart
  int placeId;
  int id;
  List<String> boundingbox;
  String lat;
  String lon;
  String displayName;
  int placeRank;
  double importance;
```

# Converting GBSearchData To GBData
```dart
// GBData Class Porvided By geocoder_buddy
GBData data = await GeocoderBuddy.searchToGBData(GBSearchData data);
```

# Getting Details From Latitude/Longitude
```dart
GBLatLng position = GBLatLng(38.8951,-77.0364);
GBData data = await GeocoderBuddy.findDetails(position);
```
#

## GBData Class
```dart
  int placeId;
  String osmType;
  int id;
  String lat;
  String lon;
  int placeRank;
  double importance;
  String displayName;
  // Address Class Porvided By geocoder_buddy
  Address address;
  List<String> boundingbox;
```
## Address Class
```dart
  String road;
  String village;
  String county;
  String stateDistrict;
  String state;
  String iso31662Lvl4;
  String postcode;
  String country;
  String countryCode;
```
# Buy Me A Coffee
<a href="https://www.buymeacoffee.com/flutterbuddy">
    <img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-1.svg" height="50" target="_flutterbuddy">
</a>

# License

See [LICENSE](LICENSE)