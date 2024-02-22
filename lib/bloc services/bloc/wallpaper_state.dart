part of 'wallpaper_bloc.dart';

@immutable
abstract class WallpaperState {}

class WallpaperInitialState extends WallpaperState {}

class WallpaperLoadingState extends WallpaperState {}

class WallpaperLoadedState extends WallpaperState {
  DataPhotoModel wallpaperModel;
  WallpaperLoadedState({required this.wallpaperModel});
}

class WallpaperErrorState extends WallpaperState {
  String errorMsg;
  WallpaperErrorState({required this.errorMsg});
}

class WallpaperInternetErrorState extends WallpaperState {
  String errorMsg;
  WallpaperInternetErrorState({required this.errorMsg});
}
