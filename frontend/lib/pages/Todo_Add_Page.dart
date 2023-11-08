import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoAddPage extends StatefulWidget{
  const TodoAddPage({Key? key}) : super(key:key);

  @override
  _TodoAddPage createState() => _TodoAddPage();
}

class _TodoAddPage extends State<TodoAddPage>{
  late TextEditingController _controller;

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TextField',textDirection: TextDirection.ltr), ),
      body:  Center(
        child: Padding(
            padding:  EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Todo',
            helperText: 'Todo내용을 입력하세요',
            hintText: 'Todo',
            icon: Icon(Icons.android),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(3)
          ),
          onSubmitted: (String value) async{
            await showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title:  Text("thanks!!",textDirection: TextDirection.ltr),
                    content: Text(
                      'You typed "$value", which has length ${value.characters.length}.',textDirection: TextDirection.ltr
                    ),
                    actions: <Widget>[
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text('OK',textDirection: TextDirection.ltr),)
                    ],
                  );
                });
          },
        ))
      ),
    );

  }
}