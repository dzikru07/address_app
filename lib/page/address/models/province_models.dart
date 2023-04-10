// To parse this JSON data, do
//
//     final provinceModels = provinceModelsFromJson(jsonString);

import 'dart:convert';

ProvinceModels provinceModelsFromJson(String str) => ProvinceModels.fromJson(json.decode(str));

String provinceModelsToJson(ProvinceModels data) => json.encode(data.toJson());

class ProvinceModels {
    ProvinceModels({
        required this.id,
        required this.nama,
    });

    int id;
    String nama;

    factory ProvinceModels.fromJson(Map<String, dynamic> json) => ProvinceModels(
        id: json["id"],
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
    };
}
