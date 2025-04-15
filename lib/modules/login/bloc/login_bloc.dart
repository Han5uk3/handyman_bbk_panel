import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<CreateAccountEvent>(_createAccount);
  }

  void _createAccount(
      CreateAccountEvent event, Emitter<LoginState> emit) async {
    String uid = HiveHelper.getUID();
    emit(CreateAccountLoading());
    try {
      await FirebaseCollections.users
          .doc(uid)
          .set(event.userData.toMap())
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
}
