import 'package:beautyminder/services/todo_service.dart';

Future<void> main() async {
  final result = await TodoService.getAllTodos();

  // 결과 출력
  if (result.value != null) {
    print('Todos: ${result.value}');
  } else {
    print('Error: ${result.error}');
  }
}