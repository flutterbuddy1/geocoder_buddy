## 1.0.2

* Fix: Widened Dart SDK constraint to `>=2.16.0 <4.0.0` for Flutter 2 and modern Flutter 3 / Dart 3 compatibility (resolves #2).
* Fix: Widened `http` dependency constraint to `>=0.13.4 <2.0.0` (resolves #7, #8).
* Fix: Added required `User-Agent` header complying with Nominatim usage policy, preventing HTTP 403 Forbidden errors in Windows release mode and desktop environments (resolves #5).
* Fix: Proper URI query parameter encoding for search addresses containing spaces, commas, or non-ASCII characters (resolves #5).
* Fix: Complete null safety for all model fields (`GBData`, `Address`, `GBSearchData`, `MapData`) preventing `Expected a value of type 'String', but got one of type 'Null'` (resolves #1, #3).
* Fix: Handled Nominatim error responses (such as `Unable to geocode`) cleanly with `GeocoderException` instead of type casting crashes (resolves #3).
* Fix: Fixed duplicate `village` named parameter compiler error (resolves #6).
* Feat: Added support for `language` / `accept-language` localization in geocoding requests (resolves #1).
* Feat: Added support for `suburb`, `neighbourhood`, `quarter`, `hamlet`, `town`, `cityDistrict`, `rawAddress`, and mapped `house_number` to `houseNumber` in `Address`.
* Feat: Configurable `GeocoderBuddy.userAgent`.

## 1.0.1

* Geocoding Without Any Apikey
* Searching Addresses
* Get Lat/Lng Details
* Many More
## Try Yourself
