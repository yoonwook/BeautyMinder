import 'dart:convert';

import 'package:beautyminder/services/auth_service.dart';
import 'package:dio/dio.dart'; // DIO 패키지를 이용해 HTTP 통신

import '../../config.dart';
import '../dto/todo_model.dart';
import '../dto/user_model.dart';
import 'shared_service.dart';

class TodoService {
  // Dio 객체 생성
  static final Dio client = Dio();

  // JSON 헤더 설정
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // 공통 HTTP 옵션 설정 함수
  static Options _httpOptions(String method, Map<String, String>? headers) {
    return Options(
      method: method,
      headers: headers,
    );
  }

  // POST 방식으로 JSON 데이터 전송하는 일반 함수
  static Future<Response> _postJson(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) {
    return client.post(
      url,
      options: _httpOptions('POST', headers),
      data: body,
    );
  }

  // PUT 방식으로 JSON 데이터 전송하는 일반 함수
  static Future<Response> _putJson(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) {
    return client.put(
      url,
      options: _httpOptions('PUT', headers),
      data: body,
    );
  }

  // Get All Todos
  // test 성공
  static Future<Result<List<Todo>>> getAllTodos() async {
    final user = await SharedService.getUser();
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();
    final userId = user?.id ?? '-1';


    //요청에 집어넣을 쿼리파라미터
    // 실사용시에는 유저로뷰터 입력을 받아야함=
    final queryParameters = {
      'userId': '6522837112b53b37f109a508',
    };

    // Create the URI with the query parameter
    // 형식 : todo/all
    // 쿼리 파라미터 userId
    // ?userId = 6522837112b53b37f109a508 형식으로 API 콜 뒤에 이어져야함
    // ex) todo/all?userId = 6522837112b53b37f109a508
    // todo model에서  userId를 넣어주면됨

    final url =
        Uri.http(Config.apiURL, Config.todoAPI, {'userId': userId}).toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await authClient.get(
        url,
        options: _httpOptions('GET', headers),
      );

      print("response: ${response.data} ${response.statusCode}");
      print("token: $accessToken | $refreshToken");

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse;
        if (response.data is String) {
          decodedResponse = jsonDecode(response.data);
        } else if (response.data is Map) {
          decodedResponse = response.data;
        } else {
          return Result.failure("Unexpected response data type");
        }

        print("Todo response: $decodedResponse");
        if (decodedResponse.containsKey('todos')) {
          List<dynamic> todoList = decodedResponse['todos'];
          List<Todo> todos =
              todoList.map((data) => Todo.fromJson(data)).toList();
          print(todos);
          return Result.success(todos);
        }
        return Result.failure("Failed to get todos: No todos key in response");
      }
      return Result.failure("Failed to get todos");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // Add a new Todo
  // 테스트 성공
  static Future<Result<Todo>> addTodo(Todo todo) async {
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();


   Map<String, dynamic> map ={
   "userId": "6522837112b53b37f109a508",
   "date": "2019-08-01",
   "morningTasks": ["String"],
   "dinnerTasks":["String12"],
   };


    final url = Uri.http(Config.apiURL, Config.todoAddAPI).toString();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    // Post 형식으로 보내야됨
    // ex) "userId": "6522837112b53b37f109a508",
    //    "date": "2019-08-01",
    //    "morningTasks": ["String"],
    //    "dinnerTasks":["String12"],
    //  _postJson메서드에서 두번째 파라미터는 Map<String, dynamic> 형식임
    //  todo_model에 에 있는  toJson을 사용하면 됨


    print(todo.toJson());
    try {
      final response = await _postJson(url, todo.toJson() , headers: headers);
      print("response : ${response}");
      return Result.success(todo);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // Delete a Todo
  // test성공
  static Future<Result<String>> deleteTodo(String todoId) async {
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();


    final queryParameters = {
      'userId': '6522837112b53b37f109a508',
    };


    final url =
        Uri.http(Config.apiURL, Config.todoDelAPI + todoId).toString();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await client.delete(
        url,
        options: _httpOptions('DELETE', headers),
      );
      if (response.statusCode == 200) {
        return Result.success("Todo deleted successfully");
      }
      return Result.failure("Failed to delete todo");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // test성공
  static Future<Result<Todo>> getTodo() async {
    final user = await SharedService.getUser();
// AccessToken가지고오기
    final accessToken = await SharedService.getAccessToken();
//refreshToken 가지고오기
    final refreshToken = await SharedService.getRefreshToken();

// user.id가 있으면 userId에 user.id를 저장 없으면 -1을 저장
    final userId = user?.id ?? '-1';

    final queryParameters = {
      'userId': '6522837112b53b37f109a508',
    };

    final url = Uri.http(Config.apiURL, Config.todoAPI, queryParameters).toString();
    print(url);

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try{
      final response = await authClient.get(
        url,
          options : _httpOptions('GET', headers)
      );

      print("response : ${response.data}, statuscode : ${response.statusCode}");
      return Result.success(response.data);
    }catch(e){
      print("Todoservice : ${e}");
      return Result.failure("error");
    }
  }
  
  static Future<Result<Todo>>updateTodo(Map<String, dynamic> updateTodo) async{


    User user = User(
      id: '65445f81f354753415c09cb4',
      email: 'user@example.com',
      password: 'securepassword123',
      nickname: 'JohnDoe',
      profileImage: 'path/to/image.jpg',
      createdAt: DateTime.now(),
      authorities: 'ROLE_USER',
    );

    Todo todo = Todo(
      id: '123',
      date: DateTime.now(),
      morningTasks: ['Task 5451', 'Task 2', 'Task 3'],
      dinnerTasks: ['Task 4', 'Task 5', 'Task 6'],
      user: user,
      createdAt: DateTime.now(),
    );

    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final url = Uri.http(Config.apiURL, Config.todoUpdateAPI).toString();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try{

      final response = await _putJson(url,updateTodo , headers: headers);
      print("response : ${response}");
      return Result.success(todo);
    }catch(e){
      return Result.failure("An error occurred: $e");
    }
  }
}



// 결과 클래스
class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null; // 성공
  Result.failure(this.error) : value = null; // 실패
}
