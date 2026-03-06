import 'dart:async';

import 'package:elevate_tracking_app/core/helper/location/location_exceptions.dart'
    hide LocationServiceDisabledException;
import 'package:elevate_tracking_app/core/helper/location/loction_errors.dart'
    hide LocationException;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

@lazySingleton
class LocationService {
  final Location _location = Location();

  Future<void> _checkServiceAndPermission() async {
    // Check if location service is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw LocationServiceDisabledException();
      }
    }

    // Check location permission status
    PermissionStatus permissionStatus = await _location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();

      if (permissionStatus == PermissionStatus.denied) {
        throw LocationPermissionDeniedException();
      }

      if (permissionStatus == PermissionStatus.deniedForever) {
        await _openAppSettings();
        throw LocationPermissionPermanentlyDeniedException();
      }
    }

    if (permissionStatus == PermissionStatus.deniedForever) {
      await _openAppSettings();
      throw LocationPermissionPermanentlyDeniedException();
    }
  }

  Future<({double latitude, double longitude})> getCurrentLocation() async {
    await _checkServiceAndPermission();

    // Fetch current location
    try {
      final locationData = await _location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        throw LocationFetchException();
      }

      return (
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationFetchException();
    }
  }

  Future<void> _openAppSettings() async {
    await permission_handler.openAppSettings();
  }

  Future<StreamSubscription<LocationData>> getLocationAsStream(
    void Function(LocationData locationData) onListenFunction,
  ) async {
    await _checkServiceAndPermission();
    await _location.changeSettings(distanceFilter: 50);
    return _location.onLocationChanged.listen(onListenFunction);
  }
}
