import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'my_exceptions.dart';

class ApiHelper{

  static String baseUrl = "https://api.pexels.com/v1/";

  Future<dynamic> getApi({required String url, Map<String, String>? mHeader})async{
    try{

      var res = await http.get(Uri.parse("$url"),headers: mHeader ?? {
        "Authorization": "InFjZ5oQfW0BcZVhRiuMTe0lscHRaIdBwFN2xfOSXgja0NArz9ZnDyVJ"});

      return returnDataResponse(res);

    }on SocketException{
      throw FetchDataException(body: "Internet Error");
    }


  }


  dynamic returnDataResponse(http.Response res){
    switch(res.statusCode){

      case 200:
        var mData = res.body;
        return jsonDecode(mData);

      case 400:
        throw BadRequestException(body: res.body.toString());

      case 401:
      case 403:
      case 407:
        throw UnAuthorisedException(body: res.body.toString());

      case 500:
      default:
        throw FetchDataException(body: "Error while communicating to server");

    }
  }

}