import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_bella_italia/src/api/enviroments.dart';
import 'package:la_bella_italia/src/models/response_api.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/utils/shared_pref.dart';

import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  String _url = Enviroments.API_DELIVERY;
  String _api = '/api/users';
  BuildContext context;
  User sessionUser;
  // ignore: missing_return
  Future init(BuildContext context, {User sessionUser}) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<User> getById(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu sessión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<User>> getByDelivey() async {
    try {
      Uri url = Uri.http(_url, '$_api/findDeliverys');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu sessión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJsonList(data);
      return user.toList;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> restaurantIsAvaiable() async {
    try {
      Uri url = Uri.http(_url, '$_api/getStateRestaurant');
      final res = await http.get(url);
      final data = json.decode(res.body);
      return data;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> recoverAccountUser(String email) async {
    try {
      Uri url = Uri.http(_url, '$_api/recoverAccountUser/$email');
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> findUserEmail(String email) async {
    try {
      Uri url = Uri.http(_url, '$_api/findbyEmail/$email');
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<User> getInfoRestaurant() async {
    try {
      Uri url = Uri.http(_url, '$_api/findByRol');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu sessión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> logout(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/logout');
      String bodyparams = json.encode(
        {'id': idUser},
      );
      var headers = <String, String>{'Content-type': 'application/json'};
      final res = await http.post(url, headers: headers, body: bodyparams);
      final data = json.decode(res.body);

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

  Future<Stream> createWithImage(User user, File imagen) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      if (imagen != null) {
        request.files.add(
          http.MultipartFile(
            'image',
            http.ByteStream(imagen.openRead().cast()),
            await imagen.length(),
            filename: basename(imagen.path),
          ),
        );
      }
      request.fields['user'] = json.encode(user);
      final response = await request.send();
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseApi> setValorRestaurant(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateStateRestaurant/$id');
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.put(url, headers: headers);
      final data = json.decode(res.body);
      print(data.toString());
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> addDelivery(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/addDelivery/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(url, headers: headers);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu sessión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> deleteDelivery(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/deleteDelivery/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.delete(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> updateNotificationToken(
      String idUser, String token) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateNotificationToken');
      String bodyparams = json.encode({
        'id': idUser,
        'notification_token': token,
      });
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyparams);

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<String>> getAdminsNotificationTokens() async {
    try {
      Uri url = Uri.http(_url, '$_api/getAdminsNotificationTokens');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        // NO AUTORIZADO
        Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      final tokens = List<String>.from(data);

      return tokens;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Stream> updateUser(User user, File imagen) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = sessionUser.sessionToken;
      if (imagen != null) {
        request.files.add(
          http.MultipartFile(
            'image',
            http.ByteStream(imagen.openRead().cast()),
            await imagen.length(),
            filename: basename(imagen.path),
          ),
        );
      }
      request.fields['user'] = json.encode(user);
      final response = await request.send();
      if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu sessión expiro');
        new SharedPref().logout(context, sessionUser.id);
      }
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
