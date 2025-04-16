part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}
class ChangeLocale extends ProfileEvent {
  final String languageCode;

  const ChangeLocale({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}