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

class UpdateProfileEvent extends LoginEvent {
 
  final String username;
  final String email;
  final String address;
  final String service;
  final String experience;

  const UpdateProfileEvent({
   
    required this.username,
    required this.email,
    required this.address,
    required this.service,
    required this.experience,
  });

  @override
  List<Object> get props => [
       
        username,
        email,
        address,
        service,
        experience,
      ];
}