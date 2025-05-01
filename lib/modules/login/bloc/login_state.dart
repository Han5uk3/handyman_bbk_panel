part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

class CreateAccountLoading extends LoginState {}

class CreateAccountSuccess extends LoginState {
}

class CreateAccountFailure extends LoginState {
  final String error;

  const CreateAccountFailure(this.error);

  @override
  List<Object> get props => [error];
}

class UpdateProfileLoading extends LoginState {}

class UpdateProfileSuccess extends LoginState {}

class UpdateProfileFailure extends LoginState {
  final String error;

  const UpdateProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}