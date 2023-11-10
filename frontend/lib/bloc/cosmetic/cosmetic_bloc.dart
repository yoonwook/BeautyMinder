import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/cosmetic_service.dart';
import '/dto/cosmetic_model.dart';
import 'cosmetic_event.dart';  // 이벤트 import
import 'cosmetic_state.dart';  // 상태 import

class CosmeticBloc extends Bloc<CosmeticEvent, CosmeticState> {
  List<Cosmetic> allCosmetics = [];  // 전체 화장품 목록을 저장
  CosmeticBloc() : super(CosmeticInitial()) {
    on<FetchCosmetics>(_onFetchCosmetics);
    on<DeleteCosmetic>(_onDeleteCosmetic);
    on<SearchCosmetics>(_onSearchCosmetics);
    add(FetchCosmetics());  // 이 추가
  }

  Future<void> _onFetchCosmetics(FetchCosmetics event, Emitter<CosmeticState> emit) async {
    try {
      allCosmetics = await CosmeticService.getAllCosmetics();  // 데이터를 allCosmetics에 저장
      print('All Cosmetics: $allCosmetics');  // 리스트의 내용을 출력
      emit(CosmeticLoaded(allCosmetics));
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

  Future<void> _onSearchCosmetics(SearchCosmetics event, Emitter<CosmeticState> emit) async {
    print('Search Event Received: ${event.query}');
    final filteredCosmetics = _searchCosmetics(allCosmetics, event.query);
    emit(CosmeticLoaded(filteredCosmetics));
  }

  // CosmeticBloc 내부에서 검색 로직 처리
  List<Cosmetic> _searchCosmetics(List<Cosmetic> cosmetics, String query) {
    final filtered = cosmetics
        .where((cosmetic) => cosmetic.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print('Filtered Cosmetics: $filtered');
    return filtered;
  }
}
