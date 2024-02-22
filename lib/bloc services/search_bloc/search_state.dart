part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  DataPhotoModel searchModel;
  SearchLoadedState({required this.searchModel});
}

class SearchErrorState extends SearchState {
  String errorMsg;
  SearchErrorState({required this.errorMsg});
}

class SearchInternetErrorState extends SearchState {
  String errorMsg;
  SearchInternetErrorState({required this.errorMsg});
}

