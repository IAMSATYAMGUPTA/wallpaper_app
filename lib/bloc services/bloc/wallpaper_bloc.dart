import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wallpaper_app/Api/urls.dart';

import '../../Api/api_helper.dart';
import '../../Api/my_exceptions.dart';
import '../../model/data_photo_model.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  ApiHelper apiHelper;
  WallpaperBloc({required this.apiHelper}) : super(WallpaperInitialState()) {
    on<GetTrendingWallpaper>((event, emit) async{
      emit(WallpaperLoadingState());
      try{
        var data = await apiHelper.getApi(url: "${Urls.trendingWallpaper}");
        emit(WallpaperLoadedState(wallpaperModel: DataPhotoModel.fromJson(data)));
      }catch(e){
        if(e is FetchDataException){
          emit(WallpaperInternetErrorState(errorMsg: e.ToString()));
        } else {
          emit(WallpaperErrorState(errorMsg: (e as MyException).ToString()));
        }
      }
    });
  }
}
