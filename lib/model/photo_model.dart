import 'package:wallpaper_app/model/src_model.dart';

class PhotoModel{
  String? alt;
  String? avg_color;
  int? height;
  int? id;
  bool? liked;
  int? photographer_id;
  String? photographer;
  String? photographer_url;
  SrcModel? src;
  String? url;
  int? width;

  PhotoModel({
    this.alt,
    this.avg_color,
    this.height,
    this.id,
    this.liked,
    this.photographer_id,
    this.photographer,
    this.photographer_url,
    this.src,
    this.url,
    this.width});

  factory PhotoModel.fromJson(Map<String, dynamic> json){
    return PhotoModel(
        alt : json['alt'],
        avg_color : json['avg_color'],
        height : json['height'],
        id : json['id'],
        liked : json['liked'],
        photographer_id : json['photographer_id'],
        photographer : json['photographer'],
        photographer_url : json['photographer_url'],
        src : SrcModel.fromJson(json['src']),
        url : json['url'],
        width : json['width']
    );
  }
}