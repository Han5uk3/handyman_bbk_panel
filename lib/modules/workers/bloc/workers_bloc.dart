import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/services/locator_services.dart';
import 'package:handyman_bbk_panel/services/storage_services.dart';
part 'workers_event.dart';
part 'workers_state.dart';

class WorkersBloc extends Bloc<WorkersEvent, WorkersState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  WorkersBloc() : super(WorkersInitial()) {
    on<VerifyWorkerEvent>(_verifyWorker);
    on<DeactivateWorkerEvent>(_deactivateWorker);
    on<SwitchToOnlineEvent>(_switchToOnline);
    on<SwitchToOfflineEvent>(_switchToOffline);
    on<AssignWorkerToAProjectEvent>(_assignWorkerToAProject);
    on<RejectWorkEvent>(_rejectWork);
    on<AcceptWorkEvent>(_acceptWork);
    on<StartJobEvent>(_startJob);
    on<EndWorkAndMarkAsCompletedEvent>(_endWorkAndMarkAsCompletedEvent);
  }

  void _verifyWorker(
      VerifyWorkerEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(WorkersVerificationLoading());
      await FirebaseCollections.workers.doc(event.workerId).update({
        'isVerified': true,
      });
      emit(WorkersVerificationSuccess());
    } catch (e) {
      emit(WorkersVerificationFailure(error: e.toString()));
    }
  }

  void _deactivateWorker(
      DeactivateWorkerEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(WorkersVerificationLoading());
      await FirebaseCollections.workers.doc(event.workerId).update({
        'isVerified': false,
        'isUserOnline': false,
      });
      emit(WorkersVerificationSuccess());
    } catch (e) {
      emit(WorkersVerificationFailure(error: e.toString()));
    }
  }

  void _switchToOnline(
      SwitchToOnlineEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(SwitchToOnlineLoading());
      await FirebaseCollections.workers.doc(event.workerId).update({
        'isUserOnline': true,
      });
      emit(SwitchToOnlineSuccess());
    } catch (e) {
      emit(SwitchToOnlineFailure(error: e.toString()));
    }
  }

  void _switchToOffline(
      SwitchToOfflineEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(SwitchToOfflineLoading());
      await FirebaseCollections.workers.doc(event.workerId).update({
        'isUserOnline': false,
      });
      emit(SwitchToOfflineSuccess());
    } catch (e) {
      emit(SwitchToOfflineFailure(error: e.toString()));
    }
  }

  void _assignWorkerToAProject(
      AssignWorkerToAProjectEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(AssignWorkerToAProjectLoading());

      final updateData = {
        'workerData': event.workerData.toMap(),
        'status': 'S',
        'assignedDateTime': FieldValue.serverTimestamp(),
      };

      if (event.isUrgentRequest) {
        updateData.addAll({
          'status': 'U',
          'visibleToWorkers': [event.workerData.uid],
        });
      }

      await FirebaseCollections.bookings
          .doc(event.projectId)
          .update(updateData);

      emit(AssignWorkerToAProjectSuccess());
    } catch (e) {
      emit(AssignWorkerToAProjectFailure(error: e.toString()));
    }
  }

  void _rejectWork(RejectWorkEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(RejectWorkLoading());
      await FirebaseCollections.bookings.doc(event.projectId).update({
        'status': 'P',
        'isWorkerAccept': false,
        'workerData': null,
        'assignedDateTime': null,
      });
      emit(RejectWorkSuccess());
    } catch (e) {
      emit(RejectWorkFailure(error: e.toString()));
    }
  }

  void _acceptWork(AcceptWorkEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(AcceptWorkLoading());
      final bookingDoc =
          await FirebaseCollections.bookings.doc(event.projectId).get();
      final bookingData = bookingDoc.data() as Map<String, dynamic>?;

      final updateData = {
        'isWorkerAccept': true,
        'status': 'A',
        'acceptedDateTime': FieldValue.serverTimestamp(),
      };

      if (bookingData == null || bookingData['workerData'] == null) {
        updateData['workerData'] = event.workerData.toMap();
      }

      await FirebaseCollections.bookings
          .doc(event.projectId)
          .update(updateData);

      emit(AcceptWorkSuccess());
    } catch (e) {
      emit(AcceptWorkFailure(error: e.toString()));
    }
  }

  void _startJob(StartJobEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(StartJobLoading());
      LocationResult locationResult = await LocationService().fetchLocation();
      if (locationResult.status == LocationFetchStatus.success) {
        await FirebaseCollections.bookings.doc(event.bookingId).update({
          'status': 'W',
        });
        _startListeningLocation(event.bookingId);
        emit(StartJobSuccess());
      } else if (locationResult.status ==
              LocationFetchStatus.permissionDenied ||
          locationResult.status ==
              LocationFetchStatus.permissionDeniedForever) {
        emit(StartJobFailure(error: 'Location permission denied.'));
      } else {
        emit(StartJobFailure(
            error: locationResult.error ?? 'Failed to fetch location.'));
      }
    } catch (e) {
      emit(StartJobFailure(error: e.toString()));
    }
  }

  void _endWorkAndMarkAsCompletedEvent(
      EndWorkAndMarkAsCompletedEvent event, Emitter<WorkersState> emit) async {
    try {
      String? imageUrl;
      emit(EndJobLoading());
      if (event.afterImage != null) {
        await StorageService.uploadFile(
                filePath: event.afterImage!.path,
                fileName: event.afterImage!.path.split('/').last)
            .then((value) {
          imageUrl = value;
        });
      }
      await FirebaseCollections.bookings.doc(event.bookingId).update({
        'status': 'C',
        'afterImage': imageUrl,
        'completedDateTime': FieldValue.serverTimestamp(),
      });
      _positionStreamSubscription?.cancel();
      emit(EndJobSuccess());
    } catch (e) {
      emit(EndJobFailure(error: e.toString()));
    }
  }

  void _startListeningLocation(String bookingId) {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) async {
      double latitude = position.latitude;
      double longitude = position.longitude;
      try {
        await FirebaseCollections.bookings.doc(bookingId).update({
          'workerData.latitude': latitude,
          'workerData.longitude': longitude,
        });
      } catch (e) {
        print('Error updating location: $e');
      }
    });
  }
}
