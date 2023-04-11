part of 'address_cubit_cubit.dart';

abstract class AddressCubitState extends Equatable {
  const AddressCubitState();

  @override
  List<Object> get props => [];
}

class AddressCubitInitial extends AddressCubitState {}

class LocalDataSuccess extends AddressCubitInitial {
  List<AddressModels> listData;

  LocalDataSuccess(this.listData);
}

class LocalDataLoading extends AddressCubitInitial {}

class SuccessAddData extends AddressCubitState {}

class SuccessChangeData extends AddressCubitState {}
