import 'package:beautyminder/State/TodoState.dart';
import 'package:beautyminder/dto/todo_model.dart';
import 'package:beautyminder/event/TodoPageEvent.dart';
import 'package:beautyminder/services/todo_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPageBloc extends Bloc<TodoPageEvent, TodoState>{

  TodoPageBloc() : super(const TodoInitState()){
    on<TodoPageInitEvent>(_initEvent);
    on<TodoPageAddEvent>(_addEvent);
    on<TodoPageUpdateEvent>(_updateEvent);
    on<TodoPageDeleteEvent>(_deleteEvent);
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

  // Todo를 추가하는 Event
  Future<void> _addEvent(TodoPageAddEvent event, Emitter<TodoState> emit) async{
    if(state is TodoLoadedState){
      // Todo가 로드된 상태에서만 Todo add event가 가능
      emit(TodoAddState());

      try{
        final Todo todo = event.todo;

        final result = await TodoService.addTodo(todo);

        if(result.value != null){
          emit(TodoAddedState());
          print(todo);
        }else{
          print("Error : ${result.error}");
        }
      }catch(e){
        print("Error : ${e}");
      }
    }else{
      emit(TodoErrorState(isError: true));
    }
  }

  Future<void> _updateEvent(TodoPageUpdateEvent event, Emitter<TodoState> emit) async{
    if(state is TodoLoadedState){
      emit(TodoUpdateState());

      try{
        final Map<String, dynamic> update_todo = event.update_todo;
        final result = await TodoService.taskUpdateTodo(update_todo);

        if(result.value != null){
          emit(TodoUpdatedState());
          print(update_todo);
        }else{
          emit(TodoErrorState(isError: true));
        }

      }catch(e){
        print("Error : ${e}");
      }

    }else{
      emit(TodoErrorState());
    }
  }

  Future<void> _deleteEvent(TodoPageDeleteEvent event, Emitter<TodoState> emit) async{
    if(state is TodoLoadedState){
      emit(TodoDeleteState());

      try{
        final String? todoid = event.todo.id;
        final result = await TodoService.deleteTodo(todoid);

        if(result.value != null){
          emit(TodoDeletedState());
          print(todoid);
        }else{
          emit(TodoErrorState(isError: true));
        }

      }catch(e){
        print("Error: ${e}");
      }
    }else{
      emit(TodoErrorState(isError: true));
    }
  }

}