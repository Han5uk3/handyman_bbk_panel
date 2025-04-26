part of 'workers_bloc.dart';

sealed class WorkersEvent extends Equatable {
  const WorkersEvent();

  @override
  List<Object> get props => [];
}

class VerifyWorkerEvent extends WorkersEvent {
  final String workerId;
  const VerifyWorkerEvent({required this.workerId});

  @override
  List<Object> get props => [workerId];
}

class DeactivateWorkerEvent extends WorkersEvent {
  final String workerId;
  const DeactivateWorkerEvent({required this.workerId});

  @override
  List<Object> get props => [workerId];
}

class SwitchToOnlineEvent extends WorkersEvent {
  final String workerId;
  const SwitchToOnlineEvent({required this.workerId});

  @override
  List<Object> get props => [workerId];
}

class SwitchToOfflineEvent extends WorkersEvent {
  final String workerId;
  const SwitchToOfflineEvent({required this.workerId});
  @override
  List<Object> get props => [workerId];
}

class AssignWorkerToAProjectEvent extends WorkersEvent {
  final UserData workerData;
  final String projectId;
  final bool isUrgentRequest;
  const AssignWorkerToAProjectEvent({
    required this.workerData,
    required this.projectId,
    this.isUrgentRequest = false,
  });
  @override
  List<Object> get props => [workerData, projectId, isUrgentRequest];
}

class RejectWorkEvent extends WorkersEvent {
  final String projectId;
  const RejectWorkEvent({required this.projectId});
  @override
  List<Object> get props => [projectId];
}

class AcceptWorkEvent extends WorkersEvent {
  final String projectId;
  final UserData workerData;
  const AcceptWorkEvent({
    required this.projectId,
    required this.workerData,
  });
  @override
  List<Object> get props => [projectId, workerData];
}

class StartJobEvent extends WorkersEvent {
  final String bookingId;
  const StartJobEvent({required this.bookingId});
  @override
  List<Object> get props => [bookingId];
}

class EndWorkAndMarkAsCompletedEvent extends WorkersEvent {
  final String bookingId;
  final File? afterImage;
  const EndWorkAndMarkAsCompletedEvent(
      {required this.bookingId, this.afterImage});
  @override
  List<Object> get props => [bookingId];
}
