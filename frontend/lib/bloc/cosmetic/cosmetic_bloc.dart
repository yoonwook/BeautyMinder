import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/cosmetic_service.dart';
import '/dto/cosmetic_model.dart';
import 'cosmetic_event.dart';  // 이벤트 import
import 'cosmetic_state.dart';  // 상태 import

class CosmeticBloc extends Bloc<CosmeticEvent, CosmeticState> {
  CosmeticBloc() : super(CosmeticInitial()) {
    on<FetchCosmetics>(_onFetchCosmetics);
    on<DeleteCosmetic>(_onDeleteCosmetic);
  }

  Future<void> _onFetchCosmetics(FetchCosmetics event, Emitter<CosmeticState> emit) async {
    try {
      final cosmetics = await CosmeticService.getAllCosmetics();
      emit(CosmeticLoaded(cosmetics));
    } catch (e) {
      emit(CosmeticError(e.toString()));
    }
  }

  Future<void> _onDeleteCosmetic(DeleteCosmetic event, Emitter<CosmeticState> emit) async {
    try {
      await CosmeticService.deleteCosmetic(event.id);
      final cosmetics = await CosmeticService.getAllCosmetics();
      emit(CosmeticLoaded(cosmetics));
    } catch (e) {
      emit(CosmeticError(e.toString()));
    }
  }
}
