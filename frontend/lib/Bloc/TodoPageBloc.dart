import 'package:beautyminder/State/TodoState.dart';
import 'package:beautyminder/dto/todo_model.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPageBloc extends Bloc<TodoPageEvent, TodoState>{

  TodoPageBloc() : super(const TodoInitState()){
    on<TodoPageInitEvent>(_initEvent);
    on<TodoPageAddEvent>(_addEvent);
    //on<TodoPageUpdateEvent>(_updateEvent);
    //on<TodoPageDeleteEvent>(_deleteEvent);
  }

  // Todo를 불러오는 Event
  Future<void> _initEvent(TodoPageInitEvent event, Emitter<TodoState> emit) async{
    emit(TodoDownloadedState(isError: state.isError));

    // userId를 통해서 todo받아오기
    // 없으면 아무것도 노출 안됨
    final result = (await TodoService.getAllTodos());

    List<Todo>? todos = result.value;

    if(todos != null){
      //정상적으로 데이터를 받아옴
      emit(TodoLoadedState(todos: todos, isError: state.isError));
    }else{
      emit(TodoErrorState(isError: state.isError));
    }
  }

  Future<void> _addEvent(TodoPageAddEvent event, Emitter<TodoState> emit) async{
    if(state is TodoLoadedState){
      emit(TodoAddState())
    }
  }

}