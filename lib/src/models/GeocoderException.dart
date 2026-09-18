/// Exception thrown when a geocoding or reverse-geocoding request fails.
class GeocoderException implements Exception {
  /// Error message describing the failure.
  final String message;

  /// Optional HTTP status code associated with the failure.
  final int? statusCode;

  GeocoderException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'GeocoderException: $message (status code: $statusCode)';
    }
    return 'GeocoderException: $message';
  }
}
