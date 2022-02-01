import 'dart:convert';

import 'package:la_bella_italia/src/models/rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String name;
  String lastname;
  String email;
  String phone;
  String password;
  String sessionToken;
  String notificationToken;
  String image;
  // ignore: non_constant_identifier_names
  bool is_avaiable;

  List<Rol> roles = [];
  List<User> toList = [];

  User({
    this.id,
    this.name,
    this.lastname,
    this.email,
    this.phone,
    this.password,
    this.sessionToken,
    this.image,
    this.roles,
    // ignore: non_constant_identifier_names
    this.is_avaiable,
    this.toList,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] is int ? json['id'].toString() : json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        sessionToken: json["session_token"],
        image: json["image"],
        is_avaiable: json["is_avaiable"],
        roles: json["roles"] == null
            ? []
            : List<Rol>.from(
                    json['roles'].map((model) => Rol.fromJson(model))) ??
                [],
      );

  User.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      // ignore: unused_local_variable
      User user = User.fromJson(item);
      toList.add(user);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "password": password,
        "session_token": sessionToken,
        "image": image,
        "is_avaiable": is_avaiable,
        "roles": roles
      };
}
