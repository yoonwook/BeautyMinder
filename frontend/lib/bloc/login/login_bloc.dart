import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/api_service.dart';
import '/dto/login_request_model.dart';

import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginStarted>(_loginStartedHandler);
  }

  Future<void> _loginStartedHandler(LoginStarted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final result = await APIService.login(LoginRequestModel(email: event.email, password: event.password));
      if (result.value == true) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: result.error ?? "Login Failed"));
      }
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}

