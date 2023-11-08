import 'dart:convert';

import 'package:beautyminder/dto/task_model.dart';
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
  // queryParmeter로 userId가 필요함
  static Future<Result<List<Todo>>> getAllTodos() async {
    final user = await SharedService.getUser();
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();
    final userId = user?.id ?? '-1';

    //요청에 집어넣을 쿼리파라미터
    // 실사용시에는 유저로뷰터 입력을 받아야함=
    final queryParameters = {
      'userId': '65499d8316f366541e3cc0a2',
    };

    // Create the URI with the query parameter
    // 형식 : todo/all
    // 쿼리 파라미터 userId
    // ?userId = 6522837112b53b37f109a508 형식으로 API 콜 뒤에 이어져야함
    // ex) todo/all?userId = 6522837112b53b37f109a508
    // todo model에서  userId를 넣어주면됨

    final url = Uri.http(Config.apiURL, Config.todoAPI,
            /*{'userId': userId}*/ queryParameters)
        .toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await authClient.get(
        url,
        options: _httpOptions('GET', headers),
      );

      //print("response: ${response.data} ${response.statusCode}");
      print("statusCode : ${response.statusCode}");
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

        if (decodedResponse.containsKey('todos')) {
          List<dynamic> todoList = decodedResponse['todos'];
          try {
            List<Todo> todos =
                todoList.map((data) => Todo.fromJson(data)).toList();
            return Result.success(todos);
          } catch (e) {
            print("Error : ${e}");
          }
        }
        return Result.failure("Failed to get todos: No todos key in response");
      }
      return Result.failure("Failed to get todos");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // Add a new Todo
  // Todo를 추가
  // 테스트 성공
  static Future<Result<Todo>> addTodo(Todo todo) async {
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    //   // 첫 번째 Task 객체 생성
    //   Task tas1 = Task(
    //     taskId: 'task_001',
    //     category: 'morning',
    //     description: '밥묵재이~',
    //     done: false,
    //   );
    //
    //
    //   List<Task> tasks = [tas1];
    //
    //   User user = User(
    //     id: '65499d8316f366541e3cc0a2',
    //     email: 'user@example.com',
    //     password: 'securepassword123',
    //     nickname: 'JohnDoe',
    //     profileImage: 'path/to/image.jpg',
    //     createdAt: DateTime.now(),
    //     authorities: 'ROLE_USER',
    //     phoneNumber: '0100101',
    //   );
    //
    //   Todo todo = Todo(
    //     id :'ddaa11',
    //     user: user,
    //     date: DateTime.now(),
    //     tasks: tasks,
    //     createdAt: DateTime.now()
    //   );
    print("addTodo ${todo.toJson()}");

    final url = Uri.http(Config.apiURL, Config.todoAddAPI).toString();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    Map<String, dynamic> k = {
      "userId": "65499d8316f366541e3cc0a2",
      "date": "2023-09-23",
      "tasks": [
        {
          "taskId": "String",
          "description": "캡디테스트23",
          "category": "morning",
          "done": false
        }
      ],
      "createdAt": "2023-11-08T14:19:03.325"
    };

    //print(jsonEncode(k));
    try {
      print("요청 보낸");
      final response =
          await _postJson(url, /*todo.toJson()*/ k, headers: headers);
      print("response : ${response}");
      return Result.success(todo);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // Delete a Todo
  // test성공
  static Future<Result<String>> deleteTodo(String? todoId) async {
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final queryParameters = {
      'userId': '6522837112b53b37f109a508',
    };

    final url = Uri.http(Config.apiURL,
            Config.todoDelAPI + todoId! /*"654a1d2a3df3381bf37bbbfd"*/)
        .toString();
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

    final url =
        Uri.http(Config.apiURL, Config.todoAPI, queryParameters).toString();
    print(url);

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response =
          await authClient.get(url, options: _httpOptions('GET', headers));

      print("response : ${response.data}, statuscode : ${response.statusCode}");
      return Result.success(response.data);
    } catch (e) {
      print("Todoservice : ${e}");
      return Result.failure("error");
    }
  }

  // API 연동 성공
  // updateTodo를
  static Future<Result<Map<String, dynamic>>> taskUpdateTodo(
      Map<String, dynamic> updateTodo) async {
    final accessToken = await SharedService.getAccessToken();
    final refreshToken = await SharedService.getRefreshToken();

    final url = Uri.http(
      Config.apiURL,
      "${Config.todoUpdateAPI}/654a083c247cdf2886c149cb",
    ).toString();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    Map<String, dynamic> up = {
      "tasksToUpdate": [
        {
          "taskId": "fe310992-590e-48d4-b24b-5b86dbb7b803",
          "description": "Submit report",
          "category": "Work",
          "isDone": true
        },
        // 여기에 더 많은 tasksToUpdate 객체를 추가할 수 있습니다.
      ],
      "tasksToAdd": [
        // tasksToAdd 객체를 추가하고 싶다면 여기에 추가합니다.
      ],
      "taskIdsToDelete": [
        "a59a6692-f9a0-4349-8ce0-6cd420e91b6e",
        "9203bd54-6eea-4261-a8ef-7ab356491d5c"
        // 여기에 더 많은 taskIdsToDelete를 추가할 수 있습니다.
      ],
    };

    try {
      final response = await _putJson(url, up, headers: headers);
      print("response : ${response}");
      return Result.success(updateTodo);
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }

  // 존재하는 Todo를 수정하는 메서드 구현필요
  //static Future<Result<Todo>> existingUpdateTodo(Todo todo){
}

// 결과 클래스
class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null; // 성공
  Result.failure(this.error) : value = null; // 실패
}
