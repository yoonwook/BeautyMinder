part of 'cosmetic_expiry_bloc.dart';

abstract class CosmeticExpiryState {}

class CosmeticExpiryInitial extends CosmeticExpiryState {}

class CosmeticExpiryLoading extends CosmeticExpiryState {}

class CosmeticExpiryLoaded extends CosmeticExpiryState {
  final List<CosmeticExpiry> cosmeticExpiryList;

  CosmeticExpiryLoaded(this.cosmeticExpiryList);
}

class CosmeticExpiryError extends CosmeticExpiryState {
  final String message;

  CosmeticExpiryError(this.message);

  String get error => message;
}


class CosmeticSearched extends CosmeticExpiryState {
  final List<Cosmetic> cosmetics;

  CosmeticSearched(this.cosmetics);
}

