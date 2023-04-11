import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/model/list_models.dart';

part 'address_cubit_state.dart';

class AddressCubitCubit extends Cubit<AddressCubitState> {
  AddressCubitCubit() : super(AddressCubitInitial());

  List<AddressModels> listData = [];

  getDataLocal() async {
    emit(LocalDataLoading());
    final prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('action');
    if (action == null) {
      listData = [];
      emit(LocalDataSuccess(listData));
    } else {
      listData = addressModelsFromJson(action.toString());
      Future.delayed(Duration(milliseconds: 1000), () {
        emit(LocalDataSuccess(listData));
      });
    }
  }

  addDataToLocal(AddressModels value) async {
    emit(LocalDataLoading());
    listData.add(value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('action', jsonEncode(listData));
    inspect(listData);
    Future.delayed(Duration(milliseconds: 1000), () {
      emit(SuccessAddData());
    });
  }

  updateDataToLocal(List<AddressModels> value) async {
    emit(LocalDataLoading());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('action', jsonEncode(value));
    Future.delayed(Duration(milliseconds: 1000), () {
      emit(SuccessChangeData());
    });
  }
}
