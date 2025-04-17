part of 'workers_bloc.dart';

sealed class WorkersState extends Equatable {
  const WorkersState();

  @override
  List<Object> get props => [];
}

final class WorkersInitial extends WorkersState {}

final class WorkersVerificationLoading extends WorkersState {}

final class WorkersVerificationSuccess extends WorkersState {}

final class WorkersVerificationFailure extends WorkersState {
  final String error;
  const WorkersVerificationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class DeactivateWorkerLoading extends WorkersState {}

final class DeactivateWorkerSuccess extends WorkersState {}

final class DeactivateWorkerFailure extends WorkersState {
  final String error;
  const DeactivateWorkerFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class SwitchToOnlineLoading extends WorkersState {}

final class SwitchToOnlineSuccess extends WorkersState {}

final class SwitchToOnlineFailure extends WorkersState {
  final String error;
  const SwitchToOnlineFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class SwitchToOfflineLoading extends WorkersState {}

final class SwitchToOfflineSuccess extends WorkersState {}

final class SwitchToOfflineFailure extends WorkersState {
  final String error;
  const SwitchToOfflineFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AssignWorkerToAProjectLoading extends WorkersState {}

class AssignWorkerToAProjectSuccess extends WorkersState {}

class AssignWorkerToAProjectFailure extends WorkersState {
  final String error;
  const AssignWorkerToAProjectFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class RejectWorkLoading extends WorkersState {}

class RejectWorkSuccess extends WorkersState {}

class RejectWorkFailure extends WorkersState {
  final String error;
  const RejectWorkFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AcceptWorkLoading extends WorkersState {}

class AcceptWorkSuccess extends WorkersState {}

class AcceptWorkFailure extends WorkersState {
  final String error;
  const AcceptWorkFailure({required this.error});

  @override
  List<Object> get props => [error];
}
