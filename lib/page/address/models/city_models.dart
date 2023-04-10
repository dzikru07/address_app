// To parse this JSON data, do
//
//     final cityModels = cityModelsFromJson(jsonString);

import 'dart:convert';

CityModels cityModelsFromJson(String str) =>
    CityModels.fromJson(json.decode(str));

String cityModelsToJson(CityModels data) => json.encode(data.toJson());

class CityModels {
  CityModels({
    required this.id,
    required this.idProvinsi,
    required this.nama,
  });

  int id;
  String idProvinsi;
  String nama;

  factory CityModels.fromJson(Map<String, dynamic> json) => CityModels(
        id: json["id"],
        idProvinsi: json["id_provinsi"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_provinsi": idProvinsi,
        "nama": nama,
      };
}
