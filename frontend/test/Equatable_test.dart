import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String name;
  final int age;

  User(this.name, this.age);

  @override
  List<Object> get props =>[name, age];
}

void main(){
  var user1 = User('kwak', 12);
  var user2 = User('kwak',12);

  print(user1 == user2 );
}