import 'package:equatable/equatable.dart';

import '../models/CosmeticModel.dart';

abstract class RecommendState extends Equatable {
  final String? category;
  final bool isError;
  final List<CosmeticModel>? recCosmetics;

  const RecommendState({
    this.isError = false,
    this.category = "all",
    this.recCosmetics,
  });



  @override
  List<Object?> get props => [category, isError, recCosmetics];
}


class RecommendInitState extends RecommendState{
  const RecommendInitState();

  @override
  List<Object?> get props => [];
}

class RecommendDownloadedState extends RecommendState{
  const RecommendDownloadedState({super.isError});

  @override
  List<Object?> get props => [isError];
}

class RecommendLoadedState extends RecommendState{

  const RecommendLoadedState({super.recCosmetics , super.category, super.isError});

  @override
  List<Object?> get props => [recCosmetics, category, isError];
}

class RecommendErrorState extends RecommendState{
  const RecommendErrorState({super.recCosmetics ,super.isError});

  @override
  List<Object?> get props => [recCosmetics ,isError];
}

class RecommendCategoryChangeState extends RecommendState{
  const RecommendCategoryChangeState({super.category, super.isError, super.recCosmetics});

  @override
  List<Object?> get props => [category, isError, recCosmetics];
}

class RecommendedCategoryChangeState extends RecommendState{
  const RecommendedCategoryChangeState({super.category, super.isError, super.recCosmetics});

  @override
  List<Object?> get props => [category, isError, recCosmetics];
}