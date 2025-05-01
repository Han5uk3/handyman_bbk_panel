import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/services/storage_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<CreateAccountEvent>(_createAccount);
     on<UpdateProfileEvent>(_updateProfile);
  }


  void _createAccount(
      CreateAccountEvent event, Emitter<LoginState> emit) async {
    String uid = HiveHelper.getUID();
    emit(CreateAccountLoading());

    try {
      String? profilePicUrl;
      String? idProofUrl;
      if (event.idProof != null) {
        idProofUrl = await StorageService.uploadFile(
          mainPath: "workers/$uid",
          filePath: event.idProof!.path,
          fileName: "${uid}_${DateTime.now().millisecondsSinceEpoch}",
        );
      }
      if (event.profilePic != null) {
        profilePicUrl = await StorageService.uploadFile(
          mainPath: "workers/$uid",
          filePath: event.profilePic!.path,
          fileName: "${uid}_${DateTime.now().millisecondsSinceEpoch}",
        );
      }
      await FirebaseCollections.workers
          .doc(uid)
          .set({
            ...event.userData.toMap(),
            "profilePic": profilePicUrl,
            "idProof": idProofUrl,
          })
          .then((_) => emit(CreateAccountSuccess()))
          .catchError(
        (e) {
          emit(CreateAccountFailure(e.toString()));
        },
      );
    } catch (e) {
      emit(CreateAccountFailure(e.toString()));
    }
  }
  void _updateProfile(UpdateProfileEvent event, Emitter<LoginState> emit) async {
  String uid = HiveHelper.getUID();
  emit(UpdateProfileLoading());

  try {

    final Map<String, dynamic> updatedData = {
      "username": event.username,
      "email": event.email,
      "address": event.address,
      "service": event.service,
      "experience": event.experience,
      
    };

    await FirebaseCollections.workers
        .doc(uid)
        .update(updatedData);

    emit(UpdateProfileSuccess());
  } catch (e) {
    emit(UpdateProfileFailure(e.toString()));
  }
}
}


