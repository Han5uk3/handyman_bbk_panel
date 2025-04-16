part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Locale locale;

  const ProfileState({this.locale = const Locale('en')});

  ProfileState copyWith({Locale? locale}) {
    return ProfileState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}