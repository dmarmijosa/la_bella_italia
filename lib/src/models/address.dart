import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
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
  List<Address> toList = [];

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] is int ? json['id'].toString() : json['id'],
        idUser: json["id_user"],
        address: json["address"],
        town: json["town"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
      );

  Address.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Address address = Address.fromJson(item);
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