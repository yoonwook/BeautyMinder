import 'package:equatable/equatable.dart';

import '../dto/task_model.dart';
import '../dto/todo_model.dart';

abstract class TodoPageEvent extends Equatable{
  // event는 총4개
  // Init event : API를 통해 Todo를 불러오는 이벤트
  // Add event : API를 통해 Todo를 추가하는 이벤트
  // Delete event : API를 통해 Todo를 삭제하는 이벤트
  // Update event : API를 통해 Todo를 수정하는 이벤트
}

class TodoPageInitEvent extends TodoPageEvent{

  @override
  List<Object?> get props =>[];
}

class TodoPageAddEvent extends TodoPageEvent{
  // 추가할 객체를 생성
  final Todo todo;

  TodoPageAddEvent(this.todo);

  @override
  List<Object?> get props =>[todo];
}


class TodoPageDeleteEvent extends TodoPageEvent{
  final Todo todo;
  final Task task;

  TodoPageDeleteEvent(this.todo, this.task);

  @override
  List<Object?> get props =>[todo, task];
}

class TodoPageUpdateEvent extends TodoPageEvent{
  final Map<String, dynamic> update_todo;

  TodoPageUpdateEvent(this.update_todo);
  @override
  List<Object?> get props =>[update_todo];
}