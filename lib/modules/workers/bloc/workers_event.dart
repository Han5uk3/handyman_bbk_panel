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
