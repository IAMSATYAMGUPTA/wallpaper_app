import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Api/api_helper.dart';
import '../../Api/my_exceptions.dart';
import '../../Api/urls.dart';
import '../../model/data_photo_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  ApiHelper apiHelper;
  SearchBloc({required this.apiHelper}) : super(SearchInitialState()) {
    on<GetSearchWallpaper>((event, emit) async{
      emit(SearchLoadingState());
      try{
        emit(SearchLoadingState());
        var data = await apiHelper.getApi(url: "${Urls.searchWallpaper}?query=${event.query}&color=${event.mColor ?? ""}&page=${event.pageNo}");
        emit(SearchLoadedState(searchModel: DataPhotoModel.fromJson(data)));
      }catch(e){
        if(e is FetchDataException){
          emit(SearchInternetErrorState(errorMsg: e.ToString()));
        } else {
          emit(SearchErrorState(errorMsg: (e as MyException).ToString()));
        }
      }

    });
  }


}
