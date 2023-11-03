import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../dto/todo_model.dart';

abstract class TodoState extends Equatable{

  // 필요한 요소 더 추가해야됨
  final bool isError;
  final List<Todo>? todos;
  final Todo? todo;// 삭제, 수정에 사용될 객체
  final Map<String,dynamic>? update_todo;

  const TodoState({
    this.isError = false,
    this.todos,
    this.todo,
    this.update_todo
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
  TodoAddState({ super.todo,super.isError});

  @override
  List<Object?> get props =>[ todo, isError];
}

// Todo추가가 성공한 상태
class TodoAddedState extends TodoState{
  TodoAddedState({ super.todo, super.isError});

  @override
  List<Object?> get props =>[ todo, isError];

}

//  update전 상태
class TodoUpdateState extends TodoState{


  TodoUpdateState({ super.isError,
  super.update_todo});

  @override
  List<Object?> get props =>[ update_todo, isError];
}

// update후 상태
class TodoUpdatedState extends TodoState{

  TodoUpdatedState({ super.update_todo, super.isError});

  @override
  List<Object?> get props =>[ update_todo, isError];
}

// 삭제중인 상태
class TodoDeleteState extends TodoState{
  TodoDeleteState({super.todo, super.isError});

  @override
  List<Object?> get props => [todo, isError];
}

// 삭제 완료된 상태
class TodoDeletedState extends TodoState{
  TodoDeletedState({super.todo, super.isError});

  @override
  List<Object?> get props => [todo, isError];
}

// Error가 발생했을 때 상태
class TodoErrorState extends TodoState{
  TodoErrorState({super.isError});

  @override
  List<Object?> get props => [isError];
}