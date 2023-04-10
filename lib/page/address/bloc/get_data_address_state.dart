part of 'get_data_address_bloc.dart';

@immutable
class GetDataAddressState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetDataAddressInitial extends GetDataAddressState {}

class GetDataError extends GetDataAddressState {
  String message;

  GetDataError(this.message);
}

class GetDataLoading extends GetDataAddressState {}

class GetProviceSuccess extends GetDataAddressState {
  List<ProvinceModels> listProvince;

  GetProviceSuccess(this.listProvince);
}

class GetCitySuccess extends GetDataAddressState {
  List<CityModels> listCity;

  GetCitySuccess(this.listCity);
}

class GetDistrictSuccess extends GetDataAddressState {
  List<DistrictModels> listDistrict;

  GetDistrictSuccess(this.listDistrict);
}

class GetVillageSuccess extends GetDataAddressState {
  List<VillageModels> listVillage;

  GetVillageSuccess(this.listVillage);
}
