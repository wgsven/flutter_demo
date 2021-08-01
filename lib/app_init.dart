
import 'http/url.dart';

class AppInit{
  AppInit._();
  static Future<void> init() async{
    Url.baseUrl = "http://baobab.kaiyanapp.com/api/";
    return Future.delayed(Duration(seconds: 4));
  }
}