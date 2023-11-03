import 'package:equatable/equatable.dart';

import '../dto/todo_model.dart';

abstract class TodoState extends Equatable{

  // 필요한 요소 더 추가해야됨
  final bool isError;
  final List<Todo>? todos;
  final Todo? addTodo;

  const TodoState({
    this.isError = false,
    this.todos,
    this.addTodo
});
}

//Todo 초기 상태
class TodoInitState extends TodoState{
  const TodoInitState();

  @override
  List<Object?> get props => [];
}

// Todo 로딩전 상태 --> getTodo 전
class TodoDownloadedState extends TodoState{
  const TodoDownloadedState({super.isError});

  @override
  List<Object?> get props =>[isError];
}

// Todo를 로딩 후 상태  --> Todo리스트가 노출되는 상태
class TodoLoadedState extends TodoState{
  TodoLoadedState({super.todos, super.isError});

  @override
  List<Object?> get props =>[todos, isError];
}

// Todo를 추가하려는 상태
class TodoAddState extends TodoState{
  TodoAddState({super.todos, super.addTodo, super.isError});

  @override
  List<Object?> get props =>[todos, addTodo, isError];
}

// Todo추가가 성공한 상태
class TodoAddedState extends TodoState{
  TodoAddedState({super.todos, super.addTodo, super.isError});

  @override
  List<Object?> get props =>[todos, addTodo, isError];

}

class TodoErrorState extends TodoState{
  TodoErrorState({super.isError});

  @override
  List<Object?> get props => [isError];
}