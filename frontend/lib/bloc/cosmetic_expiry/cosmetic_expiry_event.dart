part of 'cosmetic_expiry_bloc.dart';

abstract class CosmeticExpiryEvent {}

class LoadCosmeticExpiry extends CosmeticExpiryEvent {}

class AddCosmeticExpiry extends CosmeticExpiryEvent {
  final CosmeticExpiry cosmeticExpiry;

  AddCosmeticExpiry(this.cosmeticExpiry);
}

class SearchCosmetic extends CosmeticExpiryEvent {
  final String query;

  SearchCosmetic(this.query);
}

class CreateCosmeticAndExpiry extends CosmeticExpiryEvent {
  final Cosmetic cosmetic;
  final CosmeticExpiry expiry;

  CreateCosmeticAndExpiry(this.cosmetic, this.expiry);

}

class SelectCosmetic extends CosmeticExpiryEvent {
  final Cosmetic cosmetic;
  final DateTime expiryDate;

  SelectCosmetic(this.cosmetic, this.expiryDate);
}
