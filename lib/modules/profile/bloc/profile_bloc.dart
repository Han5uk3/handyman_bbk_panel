import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<ChangeLocale>(_onChangeLocale);
  }
  static Locale getSavedLocale() {
    String languageCode = HiveHelper().getUserlanguage();
    return Locale(languageCode);
  }

  void _onChangeLocale(ChangeLocale event, Emitter<ProfileState> emit) {
    HiveHelper().putUserlanguage(event.languageCode);
    emit(state.copyWith(locale: Locale(event.languageCode)));
  }
}
