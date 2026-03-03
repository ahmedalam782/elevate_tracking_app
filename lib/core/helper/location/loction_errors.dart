import 'package:easy_localization/easy_localization.dart';

/// Base exception for all location-related errors
abstract class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

/// Thrown when the device's location service is disabled
class LocationServiceDisabledException extends LocationException {
  LocationServiceDisabledException()
    : super("Location service disabled");
}

/// Thrown when the user denies location permission
class LocationPermissionDeniedException extends LocationException {
  LocationPermissionDeniedException()
    : super("Location permission denied");
}

/// Thrown when the user permanently denies location permission
class LocationPermissionPermanentlyDeniedException extends LocationException {
  LocationPermissionPermanentlyDeniedException()
    : super("Location permission denied");
}

/// Thrown when there's an error fetching the current location
///
class LocationFetchException extends LocationException {
  LocationFetchException() : super("Location permission denied");
}
