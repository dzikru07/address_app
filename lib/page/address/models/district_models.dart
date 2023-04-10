// To parse this JSON data, do
//
//     final districtModels = districtModelsFromJson(jsonString);

import 'dart:convert';

DistrictModels districtModelsFromJson(String str) => DistrictModels.fromJson(json.decode(str));

String districtModelsToJson(DistrictModels data) => json.encode(data.toJson());

class DistrictModels {
    DistrictModels({
        required this.id,
        required this.idKota,
        required this.nama,
    });

    int id;
    String idKota;
    String nama;

    factory DistrictModels.fromJson(Map<String, dynamic> json) => DistrictModels(
        id: json["id"],
        idKota: json["id_kota"],
        nama: json["nama"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_kota": idKota,
        "nama": nama,
    };
}
