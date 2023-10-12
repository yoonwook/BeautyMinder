import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/api_service.dart';
import '/dto/register_request_model.dart';

import 'register_event.dart';
import 'register_state.dart';


class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterStarted>(_registerStartedHandler);
  }

  Future<void> _registerStartedHandler(RegisterStarted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final result = await APIService.register(RegisterRequestModel(email: event.email, password: event.password));
      if (result.value != null) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure(error: result.error ?? "Registration Failed"));
      }
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }
  }
}


