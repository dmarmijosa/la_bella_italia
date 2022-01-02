import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/api/enviroments.dart';
import 'package:la_bella_italia/src/api/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';

import 'package:http/http.dart' as http;

class UserProvider {
  String _url = Enviroments.API_DELIVERY;
  String _api = '/api/users';
  BuildContext context;
  // ignore: missing_return
  Future init(BuildContext context) {
    this.context = context;
  }

  Future<ResponseApi> create(User user) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyparams = json.encode(user);
      var headers = <String, String>{'Content-type': 'application/json'};
      final res = await http.post(url, headers: headers, body: bodyparams);
      final data = json.decode(res.body);
      //print(data);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Err $e');
      return null;
    }
  }

  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({'email': email, 'password': password});
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
