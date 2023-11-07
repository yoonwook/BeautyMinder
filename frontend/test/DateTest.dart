import 'package:intl/intl.dart';

void main(){
  var now  = new DateTime.now();
  String formatDate = DateFormat('yy-MM-dd').format(now);

  print(formatDate);
}