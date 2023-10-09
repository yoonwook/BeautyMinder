class Cosmetic {
  final int id;
  final String name;
  final DateTime? expirationDate;
  final DateTime createdDate;
  final DateTime? purchasedDate;
  final Category category;
  final Status status;
  final int userId;

  Cosmetic({
    required this.id,
    required this.name,
    this.expirationDate,
    required this.createdDate,
    this.purchasedDate,
    required this.category,
    required this.status,
    required this.userId,
  });

  factory Cosmetic.fromJson(Map<String, dynamic> json) {
    return Cosmetic(
      id: json['id'],
      name: json['name'],
      expirationDate: DateTime.tryParse(json['expirationDate'] ?? ''),
      createdDate: DateTime.parse(json['createdDate']),
      purchasedDate: DateTime.tryParse(json['purchasedDate'] ?? ''),
      category: categoryFromJson(json['category']),
      status: statusFromJson(json['status']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'expirationDate': expirationDate?.toIso8601String(),
    'createdDate': createdDate.toIso8601String(),
    'purchasedDate': purchasedDate?.toIso8601String(),
    'category': categoryToJson(category),
    'status': statusToJson(status),
    'user_id': userId,
  };
}

enum Category {
  skincare,
  cleansing,
  mask,
  suncare,
  base,
  eye,
  lib,
  body,
  hair,
  nail,
  perfume,
}

enum Status {
  opened,
  unopened,
}

Category categoryFromJson(String json) {
  return Category.values.firstWhere(
          (e) => e.toString() == 'Category.$json',
      orElse: () => Category.skincare); // default value
}

String categoryToJson(Category category) => categoryToString(category);

String categoryToString(Category category) {
  switch (category) {
    case Category.skincare:
      return '스킨케어';
    case Category.cleansing:
      return '클렌징필링';
    case Category.mask:
      return '마스크팩';
  // ... 다른 카테고리들 ...
    default:
      return '스킨케어';  // 기본 값
  }
}

Status statusFromJson(String json) {
  return Status.values.firstWhere(
          (e) => statusToString(e) == json,
      orElse: () => Status.opened); // 기본 값
}

String statusToJson(Status status) => statusToString(status);

String statusToString(Status status) {
  switch (status) {
    case Status.opened:
      return '개봉';
    case Status.unopened:
      return '미개봉';
    default:
      return '개봉';  // 기본 값
  }
}