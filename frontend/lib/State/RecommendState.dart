import 'package:equatable/equatable.dart';

import '../models/CosmeticModel.dart';

abstract class RecommendState extends Equatable{ 
  final String? category;
  final bool isError;
  final List<CosmeticModel>? recCosmetics;

  final List<bool>? toggles; // 각 아이템의 토글 상태를 저장할 리스트

 const RecommendState({
    this.isError = false,
    this.category = "all",
   this.recCosmetics,
   this.toggles,
    // 초기 상태는 전체
});


  bool isToggled(int index) {
    // 인덱스가 유효한지 확인하고, 유효하다면 토글 상태를 반환합니다.
    return toggles != null && index >= 0 && index < toggles!.length && toggles![index];
  }

  // 상태를 복사하면서 토글 상태를 업데이트하는 메소드
  RecommendState copyWithToggled(int index) {
    List<bool> newToggles = List.from(toggles ?? List.filled(recCosmetics?.length ?? 0, false));
    if (index >= 0 && index < newToggles.length) {
      newToggles[index] = !newToggles[index]; // 토글 상태 반전
    }
    return this; // 상속받는 클래스에서 이 메소드를 오버라이드하여 새로운 객체를 반환하게 함
  }

  @override
  List<Object?> get props => [recCosmetics, category, isError, toggles];
}


class RecommendInitState extends RecommendState{
  const RecommendInitState();

  @override
  List<Object?> get props => [];
}

class RecommendDownloadedState extends RecommendState{
  const RecommendDownloadedState({super.isError});

  @override
  List<Object?> get props => [isError];
}

class RecommendLoadedState extends RecommendState{

  const RecommendLoadedState({super.recCosmetics , super.category, super.isError});

  @override
  List<Object?> get props => [recCosmetics, category, isError];
}

class RecommendErrorState extends RecommendState{
  const RecommendErrorState({super.recCosmetics ,super.isError});

  @override
  List<Object?> get props => [recCosmetics ,isError];
}

class RecommendCategoryChangeState extends RecommendState{
  const RecommendCategoryChangeState({super.category, super.isError, super.recCosmetics});

  @override
  List<Object?> get props => [category, isError, recCosmetics];
}

class RecommendedCategoryChangeState extends RecommendState{
  const RecommendedCategoryChangeState({super.category, super.isError, super.recCosmetics});

  @override
  List<Object?> get props => [category, isError, recCosmetics];
}