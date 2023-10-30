class Cosmetic {
  late final String? id;
  late String? name;
  late String? brand;
  late String? Category;

  Cosmetic({
    required this.id,
    required this.name,
    required this.brand,
    required this.Category,
  });

  factory Cosmetic.fromJson(Map<String, dynamic> json) {
    return Cosmetic(
        id: json["id"],
        name: json["name"],
        brand: json["brand"],
        Category: json["category"]);
  }
}
