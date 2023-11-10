
abstract class CosmeticEvent {}

class FetchCosmetics extends CosmeticEvent {}

class DeleteCosmetic extends CosmeticEvent {
  final String id;
  DeleteCosmetic(this.id);
}

class SearchCosmetics extends CosmeticEvent {
  final String query;
  SearchCosmetics(this.query);
}