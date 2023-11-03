import 'package:equatable/equatable.dart';

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
  @override
  List<Object?> get props =>[];
}

class TodoPageDeleteEvent extends TodoPageEvent{
  @override
  List<Object?> get props =>[];
}

class TodoPageUpdateEvent extends TodoPageEvent{
  @override
  List<Object?> get props =>[];
}