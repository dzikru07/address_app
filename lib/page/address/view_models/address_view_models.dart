import 'dart:developer';

import 'package:address_app/service/service.dart';
import 'package:http/http.dart' as http;

class AddressViewModels {
  ApiService _apiService = ApiService();

  getProvince() async {
    try {
      http.Response response =
          await _apiService.getApiData('/api/daerahindonesia/provinsi', null);
      return response;
    } catch (e) {
      return e;
    }
  }

  getCity(String id) async {
    var data = {"id_provinsi": id};

    try {
      http.Response response =
          await _apiService.getApiData('/api/daerahindonesia/kota', data);
      inspect(response);
      return response;
    } catch (e) {
      return e;
    }
  }

  getDistrict(String id) async {
    var data = {"id_kota": id};

    try {
      http.Response response =
          await _apiService.getApiData('/api/daerahindonesia/kecamatan', data);
      return response;
    } catch (e) {
      return e;
    }
  }

  getVillage(String id) async {
    var data = {"id_kecamatan": id};

    try {
      http.Response response =
          await _apiService.getApiData('/api/daerahindonesia/kelurahan', data);
      return response;
    } catch (e) {
      return e;
    }
  }
}
