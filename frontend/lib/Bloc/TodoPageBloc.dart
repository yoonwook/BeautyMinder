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
    print("initEvent");

    // userId를 통해서 todo받아오기
    // 없으면 아무것도 노출 안됨
    final result = (await TodoService.getAllTodos());

    print(result.value.runtimeType);
    print("result.value in _initEvent : ${result.value}");


    try{
      List<Todo>? todos = result.value;
      if(todos != null){
        print("TodoLoadedState");
        //정상적으로 데이터를 받아옴
        emit(TodoLoadedState(todos: todos, isError: state.isError));
      }else{
        print("TodoErrorState");
        emit(TodoErrorState(isError: state.isError));
      }
    }catch(e){
      print("Error : ${e}");
    }

  }

  // Todo를 추가하는 Event
  Future<void> _addEvent(TodoPageAddEvent event, Emitter<TodoState> emit) async{
    print("addevent");
    if(state is TodoLoadedState){
      print("TodoLoadedstate in addevent");
      // Todo가 로드된 상태에서만 Todo add event가 가능
      emit(TodoAddState(todo: state.todo ,isError: state.isError));
      print("state.todo : ${state.todo}");
      try{
        final Todo todo = event.todo;
        print("event.todo : ${event.todo}");
        print("call addTodo in addEvent");
        final result = await TodoService.addTodo(todo);
        print("result.value : ${result.value}");

        if(result.value != null){
          emit(TodoAddedState(todo: state.todo, isError: state.isError));
          print(todo);
          emit(TodoLoadedState(todos: state.todos, isError: state.isError));
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
      emit(TodoUpdateState(update_todo: state.update_todo, isError: state.isError));

      try{
        final Map<String, dynamic> update_todo = event.update_todo;
        final result = await TodoService.taskUpdateTodo(update_todo);

        if(result.value != null){
          emit(TodoUpdatedState(update_todo: state.update_todo, isError: state.isError));
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
      emit(TodoDeleteState(todo: state.todo, isError: state.isError));

      try{
        final String? todoid = event.todo.id;
        final result = await TodoService.deleteTodo(todoid);

        if(result.value != null){
          emit(TodoDeletedState(todo: state.todo, isError: state.isError));
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