part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class CreateAccountEvent extends LoginEvent {
  final UserData userData;
  const CreateAccountEvent({required this.userData});
  @override
  List<Object> get props => [userData];
}
