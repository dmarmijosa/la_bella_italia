import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  String id;
  String name;
  String description;
  String image1;
  String image2;
  String image3;
  double price;
  int idCategory;
  int quantity;
  List<Producto> toList = [];

  Producto({
    this.id,
    this.name,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.price,
    this.idCategory,
    this.quantity,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"] is int ? json["id"].toString() : json['id'],
        name: json["name"],
        description: json["description"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        price: json['price'] is String
            ? double.parse(json["price"])
            : isInteger(json["price"])
                ? json["price"].toDouble()
                : json['price'],
        idCategory: json["id_category"] is String
            ? int.parse(json["id_category"])
            : json["id_category"],
        quantity: json["quantity"],
      );

  Producto.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Producto product = Producto.fromJson(item);
      toList.add(product);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "price": price,
        "id_category": idCategory,
        "quantity": quantity,
      };

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();
}