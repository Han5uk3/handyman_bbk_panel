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
  const AssignWorkerToAProjectEvent({
    required this.workerData,
    required this.projectId,
  });
  @override
  List<Object> get props => [workerData, projectId];
}

class RejectWorkEvent extends WorkersEvent {
  final String projectId;
  const RejectWorkEvent({required this.projectId});
  @override
  List<Object> get props => [projectId];
}

class AcceptWorkEvent extends WorkersEvent {
  final String projectId;
  const AcceptWorkEvent({required this.projectId});
  @override
  List<Object> get props => [projectId];
}
