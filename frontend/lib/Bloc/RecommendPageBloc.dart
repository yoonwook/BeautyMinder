import 'dart:js_util';

import 'package:beautyminder/State/RecommendState.dart';
import 'package:beautyminder/event/RecommendPageEvent.dart';
import 'package:beautyminder/models/CosmeticModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/services/Cosmetic_Recommend_Service.dart';

late List<CosmeticModel> AllCosmetics;

class RecommendPageBloc extends Bloc<RecommendPageEvent, RecommendState>{



  RecommendPageBloc() : super(const RecommendInitState()){
  on<RecommendPageInitEvent>(_initEvent);
  on<RecommendPageCategoryChangeEvent>(_categoryChangeEvent);
  }

  Future<void> _initEvent(RecommendPageInitEvent event, Emitter<RecommendState> emit) async{
    await Future.delayed(const Duration(seconds: 0),() async {
      emit(RecommendDownloadedState(isError: state.isError));

      //추천 상품 받아오기 전체 추천상
      // 추천 상품 받아오는 로직 구현이 필요
      final result = (await CosmeticSearchService
          .getAllCosmetics());

        AllCosmetics = result.value!;

      //print("RecommendPageBloc cosmetics : ${cosmetics}");

      if (AllCosmetics != null) {
        // 정상적으로 데이터를 받아왔다면
        emit(RecommendLoadedState(
            recCosmetics: AllCosmetics, category: state.category));
      } else {
        emit(RecommendErrorState(recCosmetics: [], isError: true));
      }
    });

    }

  Future<void> _categoryChangeEvent(RecommendPageCategoryChangeEvent event , Emitter<RecommendState> emit) async{
    await Future.delayed(const Duration(seconds: 1), () async {

      if(state is RecommendLoadedState){
        // 카테고리별로 추천상품 받아오는 로직이 필요

        //print("RecommendPageBloc e.category:${event.category}");
        if(event.category == null){
          emit(RecommendCategoryChangeState(category: state.category, isError: state.isError, recCosmetics: AllCosmetics));
        }else{
          emit(RecommendCategoryChangeState(category: event.category, isError: state.isError, recCosmetics: AllCosmetics));
        }


        //print("this is categoryChageEvent");
        //print(state.recCosmetics);
        print("RecommendPageBloc category : ${state.category}");

        List<CosmeticModel>? category_select = state.recCosmetics?.where((e) {
          return e.keywords == "스킨케어";
        }).toList();


        emit(RecommendLoadedState(recCosmetics: category_select, category: state.category, isError: state.isError));


      }else{
        emit(const RecommendErrorState(recCosmetics: [], isError: true));
      }
    });
  }


  }

