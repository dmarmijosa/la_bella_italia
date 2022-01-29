import 'dart:convert';

Direccion addressFromJson(String str) => Direccion.fromJson(json.decode(str));

String addressToJson(Direccion data) => json.encode(data.toJson());

class Direccion {
  Direccion({
    this.id,
    this.idUser,
    this.address,
    this.town,
    this.lat,
    this.lng,
  });

  String id;
  String idUser;
  String address;
  String town;
  double lat;
  double lng;
  List<Direccion> toList = [];

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["id"] is int ? json['id'].toString() : json['id'],
        idUser: json["id_user"],
        address: json["address"],
        town: json["town"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
      );

  Direccion.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Direccion address = Direccion.fromJson(item);
      toList.add(address);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "address": address,
        "town": town,
        "lat": lat,
        "lng": lng,
      };
}
