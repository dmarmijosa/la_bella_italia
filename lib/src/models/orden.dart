// To parse this JSON data, do
//
//     final orden = ordenFromJson(jsonString);

import 'dart:convert';

import 'package:la_bella_italia/src/models/producto.dart';

Orden ordenFromJson(String str) => Orden.fromJson(json.decode(str));

String ordenToJson(Orden data) => json.encode(data.toJson());

class Orden {
  Orden({
    this.id,
    this.idClient,
    this.idDelivery,
    this.idAddress,
    this.status,
    this.lat,
    this.lng,
    this.timestamp,
    this.products,
  });

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

  factory Orden.fromJson(Map<String, dynamic> json) => Orden(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        idClient: json["id_client"],
        idDelivery: json["id_delivery"],
        idAddress: json["id_address"],
        status: json["status"],
        lat: json["lat"].toDouble() is String
            ? double.parse(json["lat"])
            : json["lat"],
        lng: json["lng"].toDouble() is String
            ? double.parse(json["lng"])
            : json["lng"],
        timestamp: json["timestamp"] is String
            ? int.parse(json["timestamp"])
            : json["timestamp"],
        products: List<Producto>.from(json["products"].map(
          (model) => Producto.fromJson(model) ?? [],
        )),
      );

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
      };
}
