import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Network {
  Network({this.url});
  var url;

  Future getBody() async {
    Response response = await get(url);
    return jsonDecode(response.body);
  }
}
