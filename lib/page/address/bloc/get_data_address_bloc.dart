import 'dart:convert';

import 'package:address_app/page/address/models/city_models.dart';
import 'package:address_app/page/address/models/district_models.dart';
import 'package:address_app/page/address/models/province_models.dart';
import 'package:address_app/page/address/models/village_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../view_models/address_view_models.dart';

part 'get_data_address_event.dart';
part 'get_data_address_state.dart';

class GetDataAddressBloc
    extends Bloc<GetDataAddressEvent, GetDataAddressState> {
  GetDataAddressBloc() : super(GetDataAddressInitial()) {
    AddressViewModels servicePage = AddressViewModels();
    on<GetDataAddressEvent>((event, emit) async {
      try {
        emit(GetDataLoading());
        final response = await servicePage.getProvince();
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)["provinsi"] as List;
          final listData = data.map((e) => ProvinceModels.fromJson(e)).toList();
          emit(GetProviceSuccess(listData));
        } else {
          emit(GetDataError("Error Api Code : ${response.statusCode}"));
        }
      } catch (e) {
        emit(GetDataError(e.toString()));
      }
    });
  }
}

class GetCityAddressBloc extends Bloc<GetDataCityEvent, GetDataAddressState> {
  GetCityAddressBloc() : super(GetDataAddressInitial()) {
    AddressViewModels servicePage = AddressViewModels();
    on<GetDataCityEvent>((event, emit) async {
      try {
        emit(GetDataLoading());
        final response = await servicePage.getCity(event.id!);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)["kota_kabupaten"] as List;
          final listData = data.map((e) => CityModels.fromJson(e)).toList();
          emit(GetCitySuccess(listData));
        } else {
          emit(GetDataError("Error Api Code : ${response.statusCode}"));
        }
      } catch (e) {
        emit(GetDataError(e.toString()));
      }
    });
  }
}

class GetDistrictAddressBloc
    extends Bloc<GetDataDistrictEvent, GetDataAddressState> {
  GetDistrictAddressBloc() : super(GetDataAddressInitial()) {
    AddressViewModels servicePage = AddressViewModels();

    on<GetDataDistrictEvent>((event, emit) async {
      try {
        emit(GetDataLoading());
        final response = await servicePage.getDistrict(event.id!);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)["kecamatan"] as List;
          final listData = data.map((e) => DistrictModels.fromJson(e)).toList();
          emit(GetDistrictSuccess(listData));
        } else {
          emit(GetDataError("Error Api Code : ${response.statusCode}"));
        }
      } catch (e) {
        emit(GetDataError(e.toString()));
      }
    });
  }
}

class GetVillageAddressBloc
    extends Bloc<GetDataVillageEvent, GetDataAddressState> {
  GetVillageAddressBloc() : super(GetDataAddressInitial()) {
    AddressViewModels servicePage = AddressViewModels();

    on<GetDataVillageEvent>((event, emit) async {
      try {
        emit(GetDataLoading());
        final response = await servicePage.getVillage(event.id!);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)["kelurahan"] as List;
          final listData = data.map((e) => VillageModels.fromJson(e)).toList();
          emit(GetVillageSuccess(listData));
        } else {
          emit(GetDataError("Error Api Code : ${response.statusCode}"));
        }
      } catch (e) {
        emit(GetDataError(e.toString()));
      }
    });
  }
}
