import 'dart:js_util';

import 'package:beautyminder/State/RecommendState.dart';
import 'package:beautyminder/event/RecommendPageEvent.dart';
import 'package:beautyminder/models/CosmeticModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautyminder/services/CosmeticSearch_Service.dart';

class RecommendPageBloc extends Bloc<RecommendPageEvent, RecommendState>{



  RecommendPageBloc() : super(const RecommendInitState()){
  on<RecommendPageInitEvent>(_initEvent);
  on<RecommendPageCategoryChangeEvent>(_categoryChangeEvent);
  }

  Future<void> _initEvent(RecommendPageInitEvent event, Emitter<RecommendState> emit) async{
    await Future.delayed(const Duration(seconds: 1),() async {
      emit(RecommendDownloadedState(isError: state.isError));

      //추천 상품 받아오기 전체 추천상
      // 추천 상품 받아오는 로직 구현이 필
      List<CosmeticModel> cosmetics = (await CosmeticSearchService
          .getAllCosmetics()) as List<CosmeticModel>;

      if (cosmetics != null) {
        // 정상적으로 데이터를 받아왔다면
        emit(RecommendLoadedState(
            recCosmetics: cosmetics, category: state.category));
      } else {
        emit(RecommendErrorState(recCosmetics: [], isError: true));
      }
    });

    }

  Future<void> _categoryChangeEvent(RecommendPageCategoryChangeEvent event , Emitter<RecommendState> emit) async{
    await Future.delayed(const Duration(seconds: 1), () async {
      if(state is RecommendLoadedState){
        // 카테고리별로 추천상품 받아오는 로직이 필요
        List<CosmeticModel> cosmetics = (await CosmeticSearchService.getAllCosmetics()) as List<CosmeticModel>;
        emit(RecommendLoadedState(category: state.category ,isError: state.isError ,recCosmetics: cosmetics));
      }else{
        emit(const RecommendErrorState(recCosmetics: [], isError: true));
      }
    });
  }


  }

