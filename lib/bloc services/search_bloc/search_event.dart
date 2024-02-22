part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class GetSearchWallpaper extends SearchEvent{
  String query;
  String? mColor;
  String? pageNo;
  GetSearchWallpaper({required this.query,this.mColor,this.pageNo="1"});
}
