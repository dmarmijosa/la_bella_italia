import 'dart:convert';

import 'package:la_bella_italia/src/models/direccion.dart';
import 'package:la_bella_italia/src/models/producto.dart';
import 'package:la_bella_italia/src/models/user.dart';

Orden orderFromJson(String str) => Orden.fromJson(json.decode(str));

String orderToJson(Orden data) => json.encode(data.toJson());

class Orden {
  String id;
  String idClient;
  String idDelivery;
  String idAddress;
  String status;
  double lat;
  double lng;
  int timestamp;
  List<Producto> products = [];
  List<Orden> toList = [];
  User client;
  User delivery;
  Direccion address;

  Orden(
      {this.id,
      this.idClient,
      this.idDelivery,
      this.idAddress,
      this.status,
      this.lat,
      this.lng,
      this.timestamp,
      this.products,
      this.client,
      this.delivery,
      this.address});

  factory Orden.fromJson(Map<String, dynamic> json) => Orden(
      id: json["id"] is int ? json["id"].toString() : json['id'],
      idClient: json["id_client"],
      idDelivery: json["id_delivery"],
      idAddress: json["id_address"],
      status: json["status"],
      lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
      lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
      timestamp: json["timestamp"] is String
          ? int.parse(json["timestamp"])
          : json["timestamp"],
      products: json["products"] != null
          ? List<Producto>.from(json["products"].map((model) =>
                  model is Producto ? model : Producto.fromJson(model))) ??
              []
          : [],
      client: json['client'] is String
          ? userFromJson(json['client'])
          : json['client'] is User
              ? json['client']
              : User.fromJson(json['client'] ?? {}),
      delivery: json['delivery'] is String
          ? userFromJson(json['delivery'])
          : json['delivery'] is User
              ? json['delivery']
              : User.fromJson(json['delivery'] ?? {}),
      address: json['address'] is String
          ? addressFromJson(json['address'])
          : json['address'] is Direccion
              ? json['address']
              : Direccion.fromJson(json['address'] ?? {}));

  Orden.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Orden order = Orden.fromJson(item);
      toList.add(order);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_client": idClient,
        "id_delivery": idDelivery,
        "id_address": idAddress,
        "status": status,
        "lat": lat,
        "lng": lng,
        "timestamp": timestamp,
        "products": products,
        "client": client,
        "delivery": delivery,
        "address": address,
      };
}
