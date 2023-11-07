import 'package:beautyminder/dto/task_model.dart';
import 'package:beautyminder/services/todo_service.dart';

void main() {
  // 첫 번째 Task 객체 생성
  Task task1 = Task(
    taskId: 'task_001',
    category: '아침',
    description: '아침에 할 일',
    done: false,
  );

  // 두 번째 Task 객체 생성
  Task task2 = Task(
    taskId: 'task_002',
    category: '저녁',
    description: '저녁에 할 일',
    done: true,
  );

  List<Task> tasks = [task1, task2];
  print(tasks.toString());
}