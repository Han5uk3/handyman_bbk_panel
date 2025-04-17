import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';

part 'workers_event.dart';
part 'workers_state.dart';

class WorkersBloc extends Bloc<WorkersEvent, WorkersState> {
  WorkersBloc() : super(WorkersInitial()) {
    on<VerifyWorkerEvent>(_verifyWorker);
    on<DeactivateWorkerEvent>(_deactivateWorker);
    on<SwitchToOnlineEvent>(_switchToOnline);
    on<SwitchToOfflineEvent>(_switchToOffline);
    on<AssignWorkerToAProjectEvent>(_assignWorkerToAProject);
    on<RejectWorkEvent>(_rejectWork);
    on<AcceptWorkEvent>(_acceptWork);
  }

  void _verifyWorker(
      VerifyWorkerEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(WorkersVerificationLoading());
      await FirebaseCollections.users.doc(event.workerId).update({
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
      await FirebaseCollections.users.doc(event.workerId).update({
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
      await FirebaseCollections.users.doc(event.workerId).update({
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
      await FirebaseCollections.users.doc(event.workerId).update({
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
      await FirebaseCollections.bookings.doc(event.projectId).update({
        'workerData': event.workerData.toMap(),
        'assignedDateTime': FieldValue.serverTimestamp(),
      });
      emit(AssignWorkerToAProjectSuccess());
    } catch (e) {
      emit(AssignWorkerToAProjectFailure(error: e.toString()));
    }
  }

  void _rejectWork(RejectWorkEvent event, Emitter<WorkersState> emit) async {
    try {
      emit(RejectWorkLoading());
      await FirebaseCollections.bookings.doc(event.projectId).update({
        'status': 'X',
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
      await FirebaseCollections.bookings.doc(event.projectId).update({
        'isWorkerAccept': true,
        'acceptedDateTime': FieldValue.serverTimestamp(),
      });
      emit(AcceptWorkSuccess());
    } catch (e) {
      emit(AcceptWorkFailure(error: e.toString()));
    }
  }
}
