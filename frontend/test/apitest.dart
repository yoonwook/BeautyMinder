import 'package:beautyminder/services/Cosmetic_Recommend_Service.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('getAllCosmetics 테스트', () async {
    final result = await CosmeticSearchService.getAllCosmetics();
  });
}