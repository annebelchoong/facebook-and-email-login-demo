import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'http://interview.advisoryapps.com/index.php/';
  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
    );
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    debugPrint("Full url: $fullUrl");
    return await http.get(
      Uri.parse(fullUrl),
    );
  }
}
