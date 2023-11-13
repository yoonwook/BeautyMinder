// API요청으로 받아오는 모델
class KeyWordRank{
  final List<String>? keywords;
  final String? updatedAt;


  KeyWordRank({
    required this.keywords,
    required this.updatedAt,
  });

  factory KeyWordRank.fromJson(Map<String, dynamic> json){
    return KeyWordRank(
      keywords: List<String>.from(json['keywords']),
      updatedAt: json['updatedAt'],
    );
  }

  @override
  String toString() {
    return 'KeyWordRank{keywords: ${keywords?.join(', ')}, updatedAt: $updatedAt';
  }

}
