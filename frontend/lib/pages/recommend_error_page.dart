import 'package:beautyminder/Bloc/RecommendPageBloc.dart';
import 'package:beautyminder/State/RecommendState.dart';
import 'package:beautyminder/event/RecommendPageEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecErrorPage extends StatelessWidget{
  const RecErrorPage({super.key});

  @override
  Widget build(BuildContext context){
    return BlocListener<RecommendPageBloc, RecommendState>(
        listener: (context, state){
          if(!state.isError){
            Navigator.of(context).pop();
          }
        },
      child: Scaffold(
        appBar : AppBar(title: Text("Bloc Error"),),
        body: Center(
          child: IconButton(
            iconSize: 100,
            onPressed: (){
              HapticFeedback.mediumImpact();
              context
                  .read<RecommendPageBloc>()
                  .add(RecommendPageInitEvent());
            },
            icon : const Icon(
              Icons.refresh_rounded,
            )
          )
        )
      )
    );
  }
}