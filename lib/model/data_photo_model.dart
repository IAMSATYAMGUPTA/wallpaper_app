import 'package:wallpaper_app/model/photo_model.dart';

class DataPhotoModel {
  String? next_page;
  int? page;
  int? per_page;
  int? total_results;
  List<PhotoModel>? photos;

  DataPhotoModel(
      {this.next_page,
        this.page,
        this.per_page,
        this.total_results,
        this.photos});

  factory DataPhotoModel.fromJson(Map<String, dynamic> json){

    List<PhotoModel> mPhotos = [];

    json['photos'].forEach((element) {
      mPhotos.add(PhotoModel.fromJson(element));
    });


    return DataPhotoModel(
        next_page : json['next_page'],
        page : json['page'],
        per_page : json['per_page'],
        total_results : json['total_results'],
        photos : mPhotos
    );
  }
}