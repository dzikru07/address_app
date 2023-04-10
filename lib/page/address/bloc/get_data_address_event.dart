part of 'get_data_address_bloc.dart';

@immutable
class GetDataAddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDataCityEvent extends GetDataAddressEvent {
  String? id;

  GetDataCityEvent(this.id);
}

class GetDataDistrictEvent extends GetDataAddressEvent {
  String? id;

  GetDataDistrictEvent(this.id);
}

class GetDataVillageEvent extends GetDataAddressEvent {
  String? id;

  GetDataVillageEvent(this.id);
}
