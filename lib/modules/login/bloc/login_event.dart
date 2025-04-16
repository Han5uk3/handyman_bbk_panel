part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class CreateAccountEvent extends LoginEvent {
  final UserData userData;
  final File? idProof;
  final File? profilePic;
  const CreateAccountEvent({
    required this.userData,
    this.idProof,
    this.profilePic,
  });
  @override
  List<Object> get props => [userData];
}
