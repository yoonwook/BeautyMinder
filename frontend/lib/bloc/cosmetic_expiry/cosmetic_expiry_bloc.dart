import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '/dto/cosmetic_model.dart';
import '/dto/cosmetic_expiry_model.dart';
import '/services/cosmetic_service.dart';
import '/services/expiry_service.dart';
import '/services/api_service.dart';

part 'cosmetic_expiry_event.dart';
part 'cosmetic_expiry_state.dart';

class CosmeticExpiryBloc extends Bloc<CosmeticExpiryEvent, CosmeticExpiryState> {
  CosmeticExpiryBloc() : super(CosmeticExpiryInitial()) {
    on<LoadCosmeticExpiry>(_onLoadCosmeticExpiry);
    on<AddCosmeticExpiry>(_onAddCosmeticExpiry);
  }

  Future<void> _onLoadCosmeticExpiry(LoadCosmeticExpiry event, Emitter<CosmeticExpiryState> emit) async {
    try {
      final result = await APIService.getUserProfile();
      final userId = result.isSuccess ? result.value?.id ?? '-1' : '-1';
      final expiryList = await ExpiryService.getAllExpiriesByUserId(userId);
      emit(CosmeticExpiryLoaded(expiryList));
    } catch (e) {
      emit(CosmeticExpiryError(e.toString()));
    }
  }

  Future<void> _onAddCosmeticExpiry(AddCosmeticExpiry event, Emitter<CosmeticExpiryState> emit) async {
    try {
      emit(CosmeticExpiryLoading());
      final newExpiry = event.cosmeticExpiry;
      final addedExpiry = await ExpiryService.createCosmeticExpiry(newExpiry);
      if (state is CosmeticExpiryLoaded) {
        final List<CosmeticExpiry> updatedList = List.from((state as CosmeticExpiryLoaded).cosmeticExpiryList)
          ..add(addedExpiry);
        emit(CosmeticExpiryLoaded(updatedList));
      }
    } catch (e) {
      emit(CosmeticExpiryError(e.toString()));
    }
  }
}
