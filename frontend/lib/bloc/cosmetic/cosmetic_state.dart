import '/dto/cosmetic_model.dart';

abstract class CosmeticState {}

class CosmeticInitial extends CosmeticState {}

class CosmeticLoaded extends CosmeticState {
  final List<Cosmetic> cosmetics;
  CosmeticLoaded(this.cosmetics);
}

class CosmeticSearched extends CosmeticState {
  final List<Cosmetic> cosmetics;
  CosmeticSearched(this.cosmetics);
}

class CosmeticError extends CosmeticState {
  final String message;
  CosmeticError(this.message);
}
