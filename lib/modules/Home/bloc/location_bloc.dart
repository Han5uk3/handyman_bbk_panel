import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/services/locator_services.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService;
  bool _hasBeenFetched = false;

  LocationBloc(this._locationService) : super(LocationInitial()) {
    on<FetchLocation>(_onFetchLocation);
    on<RefreshLocation>(_onRefreshLocation);
  }
  Future<void> _onFetchLocation(
    FetchLocation event,
    Emitter<LocationState> emit,
  ) async {
    if (_hasBeenFetched) return;

    await _fetchLocationData(emit);
  }

  Future<void> _onRefreshLocation(
    RefreshLocation event,
    Emitter<LocationState> emit,
  ) async {
    await _fetchLocationData(emit);
  }

  Future<void> _fetchLocationData(Emitter<LocationState> emit) async {
    emit(LocationLoading());

    final result = await _locationService.fetchLocation();

    switch (result.status) {
      case LocationFetchStatus.success:
        final fullLocation = _locationService.userLocation;
        final lastCommaIndex = fullLocation!.lastIndexOf(',');
        String mainLocation;
        String? subLocation;

        if (lastCommaIndex != -1) {
          mainLocation = fullLocation.substring(0, lastCommaIndex).trim();
          subLocation = fullLocation.substring(lastCommaIndex + 1).trim();
        } else {
          mainLocation = fullLocation;
          subLocation = _locationService.userLocality;
        }
        await FirebaseCollections.workers.doc(AppServices.uid).update({
          "longitude": _locationService.longitude,
          "latitude": _locationService.latitude,
        });

        _hasBeenFetched = true;
        emit(
          LocationLoaded(mainLocation: mainLocation, subLocation: subLocation),
        );
        break;

      case LocationFetchStatus.permissionDeniedForever:
        emit(LocationPermissionDeniedForever());
        break;

      case LocationFetchStatus.permissionDenied:
        emit(LocationPermissionDenied());
        break;

      case LocationFetchStatus.failure:
        emit(LocationError(error: result.error ?? "Unknown error"));
        break;
    }
  }
}
