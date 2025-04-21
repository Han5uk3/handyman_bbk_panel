
import 'package:geolocator/geolocator.dart';
import 'package:handyman_bbk_panel/helpers/geo_locator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  String? userLocation;
  String? userLocality;
  bool isLocationActive = false;
  double? longitude;
  double? latitude;
  String? mainLocation;
  String? subLocation;

  Future<LocationResult> fetchLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult(status: LocationFetchStatus.permissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult(
        status: LocationFetchStatus.permissionDeniedForever,
      );
    }

    try {
      FetchLocationGeolocator geolocator = FetchLocationGeolocator();
      userLocation = await geolocator.refetchLocation();
      userLocality = await geolocator.fetchLocality();
      isLocationActive = userLocation != null;

      if (isLocationActive) {
        longitude = await geolocator.fetchLongitude();
        latitude = await geolocator.fetchLatitude();
      }

      _parseLocation(userLocation!);

      return LocationResult(status: LocationFetchStatus.success);
    } catch (e) {
      return LocationResult(
        status: LocationFetchStatus.failure,
        error: e.toString(),
      );
    }
  }

  void _parseLocation(String location) {
    List<String> parts = location.split(',');

    if (parts.length >= 2) {
      subLocation = parts.last.trim();
      mainLocation = parts.sublist(0, parts.length - 1).join(',').trim();
    } else {
      mainLocation = location;
      subLocation = null;
    }
  }
}

enum LocationFetchStatus {
  success,
  permissionDenied,
  permissionDeniedForever,
  failure,
}

class LocationResult {
  final LocationFetchStatus status;
  final String? error;

  LocationResult({required this.status, this.error});
}
