import 'dart:convert';

Categoria categoriaFromJson(String str) => Categoria.fromJson(json.decode(str));

String categoriaToJson(Categoria data) => json.encode(data.toJson());

class Categoria {
  String id;
  String name;
  String description;
  List<Categoria> tolist = [];

  Categoria({
    this.id,
    this.name,
    this.description,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );
  Categoria.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Categoria categoria = Categoria.fromJson(item);
      tolist.add(categoria);
    });
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
