// To parse this JSON data, do
//
//     final addressModels = addressModelsFromJson(jsonString);

import 'dart:convert';

List<AddressModels> addressModelsFromJson(String str) =>
    List<AddressModels>.from(
        json.decode(str).map((x) => AddressModels.fromJson(x)));

String addressModelsToJson(List<AddressModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModels {
  AddressModels({
    required this.category,
    required this.country,
    required this.province,
    required this.city,
    required this.district,
    required this.village,
    required this.provinceId,
    required this.cityId,
    required this.districtId,
    required this.villageId,
    required this.postalCode,
    required this.addressName,
    required this.rt,
    required this.rw,
    required this.phoneNumber,
    required this.active,
  });

  String category;
  String country;
  String province;
  String city;
  String district;
  String village;
  String provinceId;
  String cityId;
  String districtId;
  String villageId;
  String postalCode;
  String addressName;
  String rt;
  String rw;
  String phoneNumber;
  bool active;

  factory AddressModels.fromJson(Map<String, dynamic> json) => AddressModels(
        category: json["category"],
        country: json["country"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        village: json["village"],
        provinceId: json["province_id"],
        cityId: json["city_id"],
        districtId: json["district_id"],
        villageId: json["village_id"],
        postalCode: json["postalCode"],
        addressName: json["addressName"],
        rt: json["rt"],
        rw: json["rw"],
        phoneNumber: json["phoneNumber"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "country": country,
        "province": province,
        "city": city,
        "district": district,
        "village": village,
        "province_id": provinceId,
        "city_id": cityId,
        "district_id": districtId,
        "village_id": villageId,
        "postalCode": postalCode,
        "addressName": addressName,
        "rt": rt,
        "rw": rw,
        "phoneNumber": phoneNumber,
        "active": active,
      };
}
