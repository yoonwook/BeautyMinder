class Result<T> {
  final T? value;
  final String? error;

  Result.success(this.value) : error = null; // 성공
  Result.failure(this.error) : value = null; // 실패
}

Result<int> divide(int a, int b){
  if(b==0){
    return Result.failure("error");

  }else{
    return Result.success(a ~/ b);
  }
}

void main(){
var result1 = divide(10, 2);
print(result1.value);
print(result1.error);

var result2 = divide(10,0);
print(result2.value);
print(result2.error);


}