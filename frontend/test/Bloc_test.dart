import 'package:beautyminder/Bloc/TodoPageBloc.dart';
import 'package:beautyminder/State/TodoState.dart';
import 'package:beautyminder/dto/todo_model.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/services/todo_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTodoService extends Mock implements TodoService {
  getAllTodos() {print("성공");}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TodoPageBloc Tests', () {
    late TodoPageBloc todoPageBloc;
    late MockTodoService mockTodoService;
    late List<Todo> mockTodos;

    setUp(() {
      mockTodoService = MockTodoService();
      mockTodos = [/* ... 여기에 Todo 리스트 샘플을 채워 넣으세요 ... */];
      // getAllTodos가 호출될 때 Todo 리스트를 반환하도록 설정합니다.
      when(mockTodoService.getAllTodos()).thenAnswer((_) async => mockTodos);

      todoPageBloc = TodoPageBloc();
    });

    blocTest<TodoPageBloc, TodoState>(
      'emits [TodoDownloadedState, TodoLoadedState] when TodoPageInitEvent is added',
      build: () => todoPageBloc,
      act: (bloc) => bloc.add(TodoPageInitEvent()),
      expect: () => [TodoDownloadedState(), isA<TodoLoadedState>()],
      verify: (_) {
        verify(mockTodoService.getAllTodos()).called(1);
      },
    );
  });
}
