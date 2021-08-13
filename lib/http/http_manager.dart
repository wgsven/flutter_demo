import 'dart:convert';

import 'package:flutter_open/http/url.dart';
import 'package:http/http.dart' as http;

class HttpManager {
  static Utf8Decoder utf8Decoder = Utf8Decoder();

  static void getData(
      {required String url,
      Function? success,
      Function? fail,
      Function? complete}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: Url.httpHeader);
      if (response.statusCode == 200) {
        var result = json.decode(utf8Decoder.convert(response.bodyBytes));
        if (success != null) {
          success(result);
        }
      } else {
        throw Exception("网络请求失败，状态码为：${response.statusCode}");
      }
    } catch (e) {
      if (fail != null) {
        fail(e);
      }
    } finally {
      if (complete != null) {
        complete();
      }
    }
  }

  static Future requestData(String url) async {
    try {
      var response = await http.get(Uri.parse(url), headers: Url.httpHeader);
      if (response.statusCode == 200) {
        var result = json.decode(utf8Decoder.convert(response.bodyBytes));
        return result;
      } else {
        throw Exception("网络请求失败，状态码为：${response.statusCode}");
      }
    } catch (e) {
      Future.error(e);
    }
    // finally {
    //   Future.value("complete");
    // }
  }
}
