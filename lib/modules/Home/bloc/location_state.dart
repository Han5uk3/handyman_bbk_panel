part of 'location_bloc.dart';

abstract class LocationState {
  final String? mainLocation;
  final String? subLocation;
  final bool isLoading;

  LocationState({this.mainLocation, this.subLocation, required this.isLoading});
}

class LocationInitial extends LocationState {
  LocationInitial()
    : super(mainLocation: null, subLocation: null, isLoading: false);
}

class LocationLoading extends LocationState {
  LocationLoading()
    : super(mainLocation: null, subLocation: null, isLoading: true);
}

class LocationLoaded extends LocationState {
  LocationLoaded({required String super.mainLocation, super.subLocation})
    : super(isLoading: false);
}

class LocationPermissionDenied extends LocationState {
  LocationPermissionDenied()
    : super(
        mainLocation: "Location permission denied",
        subLocation: null,
        isLoading: false,
      );
}

class LocationPermissionDeniedForever extends LocationState {
  LocationPermissionDeniedForever()
    : super(
        mainLocation: "Location permission denied forever",
        subLocation: null,
        isLoading: false,
      );
}

class LocationError extends LocationState {
  final String error;
  LocationError({required this.error})
    : super(
        mainLocation: "Location unavailable",
        subLocation: null,
        isLoading: false,
      );
}
