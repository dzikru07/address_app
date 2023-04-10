// To parse this JSON data, do
//
//     final villageModels = villageModelsFromJson(jsonString);

import 'dart:convert';

VillageModels villageModelsFromJson(String str) =>
    VillageModels.fromJson(json.decode(str));

String villageModelsToJson(VillageModels data) => json.encode(data.toJson());

class VillageModels {
  VillageModels({
    required this.id,
    required this.idKecamatan,
    required this.nama,
  });

  int id;
  String idKecamatan;
  String nama;

  factory VillageModels.fromJson(Map<String, dynamic> json) => VillageModels(
        id: json["id"],
        idKecamatan: json["id_kecamatan"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_kecamatan": idKecamatan,
        "nama": nama,
      };
}
