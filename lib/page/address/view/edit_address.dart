import 'dart:convert';
import 'dart:developer';

import 'package:address_app/page/home/model/list_models.dart';
import 'package:address_app/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicons/unicons.dart';

import '../../../style/text.dart';
import '../bloc/get_data_address_bloc.dart';
import '../cubit/address_cubit_cubit.dart';

const List<String> listCategory = <String>[
  'Rumah',
  'Kost',
  'Kontrakan',
  'Apartemen'
];

const List<String> listCountry = <String>[
  'Indonesia',
  'Malaysia',
  'Singapura',
  'Thailand'
];

const List<String> listPostalCode = <String>[
  '55532',
  '55562',
  '55598',
  '55574'
];

class DataArguments {
  final int index;
  final AddressModels data;

  DataArguments(this.index, this.data);
}

class EditAddress extends StatelessWidget {
  EditAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DataArguments;
    return Material(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetDataAddressBloc()..add(GetDataAddressEvent()),
          ),
          BlocProvider(
            create: (context) => GetCityAddressBloc()
              ..add(GetDataCityEvent(args.data.provinceId)),
          ),
          BlocProvider(
            create: (context) => GetDistrictAddressBloc()
              ..add(GetDataDistrictEvent(args.data.cityId)),
          ),
          BlocProvider(
            create: (context) => GetVillageAddressBloc()
              ..add(GetDataVillageEvent(args.data.districtId)),
          ),
          BlocProvider(
            create: (context) => AddressCubitCubit(),
          ),
        ],
        child: EditAddressBloc(
          data: args,
        ),
      ),
    );
  }
}

class EditAddressBloc extends StatefulWidget {
  EditAddressBloc({required this.data, super.key});

  DataArguments data;

  @override
  State<EditAddressBloc> createState() => _EditAddressBlocState();
}

class _EditAddressBlocState extends State<EditAddressBloc> {
  var categoryValue;
  var countryValue;
  var provinceValue, cityValue, districtValue, villageValue, postalCodeValue;

  //list data Local
  List<AddressModels> listData = [];

  //text Controller
  TextEditingController nameAddressController = TextEditingController();
  TextEditingController rtAddressController = TextEditingController();
  TextEditingController rwAddressController = TextEditingController();
  TextEditingController phoneAddressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddressCubitCubit>().getDataLocal();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameAddressController.dispose();
    rtAddressController.dispose();
    rwAddressController.dispose();
    phoneAddressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //bloc initial
    GetDataAddressBloc getProvinceBloc = context.read<GetDataAddressBloc>();
    GetCityAddressBloc getCityBloc = context.read<GetCityAddressBloc>();
    GetDistrictAddressBloc getDistrictBloc =
        context.read<GetDistrictAddressBloc>();
    GetVillageAddressBloc getVillageBloc =
        context.read<GetVillageAddressBloc>();

    double _width = MediaQuery.of(context).size.width;

    var categoryAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            width: _width,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: DropdownButton<String>(
              underline: Container(
                height: 0,
              ),
              hint: Text(
                listData[widget.data.index].category,
                style: addAddressTextCategory,
              ),
              isExpanded: true,
              value: categoryValue,
              icon: const Icon(UniconsLine.angle_down),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  categoryValue = value!;
                  listData[widget.data.index].category = categoryValue;
                });
              },
              items: listCategory.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: addAddressTextCategory,
                  ),
                );
              }).toList(),
            ),
          );

    var countryAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            width: _width,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: DropdownButton<String>(
              underline: Container(
                height: 0,
              ),
              hint: Text(
                listData[widget.data.index].country,
                style: addAddressTextCategory,
              ),
              isExpanded: true,
              value: countryValue,
              icon: const Icon(UniconsLine.angle_down),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  countryValue = value!;
                  listData[widget.data.index].country = countryValue;
                });
              },
              items: listCountry.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: addAddressTextCategory,
                  ),
                );
              }).toList(),
            ),
          );

    var provinceAddress = listData.isEmpty
        ? SizedBox()
        : BlocBuilder<GetDataAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetProviceSuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width,
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: provinceValue,
                    hint: Text(
                      provinceValue == null
                          ? listData[widget.data.index].province
                          : "Pilih Provisi",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        provinceValue = value;
                        listData[widget.data.index].province =
                            provinceValue.toString().split("/")[1];
                        listData[widget.data.index].provinceId =
                            provinceValue.toString().split("/")[0];
                        listData[widget.data.index].cityId = "0";
                        listData[widget.data.index].districtId = "0";
                        listData[widget.data.index].villageId = "0";
                        getCityBloc.add(GetDataCityEvent(
                            listData[widget.data.index].provinceId));
                      });
                    },
                    items: state.listProvince.map((value) {
                      return DropdownMenuItem(
                        value: value.id.toString() + "/" + value.nama,
                        child: Text(
                          value.nama,
                          style: addAddressTextCategory,
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (state is GetDataError) {
                return Text(state.message.toString());
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFF1A1A3F),
                      rightDotColor: const Color(0xFFEA3799),
                      size: 35,
                    ),
                  ),
                );
              }
            },
          );

    var cityAddress = listData.isEmpty
        ? SizedBox()
        : BlocBuilder<GetCityAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetCitySuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width,
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: cityValue,
                    hint: Text(
                      cityValue == null
                          ? listData[widget.data.index].cityId == '0'
                              ? 'Pilih Kabupaten/Kote'
                              : listData[widget.data.index].city
                          : "Pilih Kota",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        cityValue = value!;
                        listData[widget.data.index].city = value.split("%")[1];
                        listData[widget.data.index].cityId =
                            value.split("%")[0];
                        listData[widget.data.index].districtId = "0";
                        listData[widget.data.index].villageId = "0";
                        districtValue = null;
                        villageValue = null;
                        getDistrictBloc.add(GetDataDistrictEvent(
                            listData[widget.data.index].cityId));
                      });
                    },
                    items: state.listCity.map((value) {
                      return DropdownMenuItem(
                        value: value.id.toString() + '%' + value.nama,
                        child: Text(
                          value.nama,
                          style: addAddressTextCategory,
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (state is GetDataError) {
                return Text(state.message.toString());
              } else if (state is GetDataAddressInitial) {
                return SizedBox();
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFF1A1A3F),
                      rightDotColor: const Color(0xFFEA3799),
                      size: 35,
                    ),
                  ),
                );
              }
            },
          );

    var districtAddress = listData.isEmpty ||
            listData[widget.data.index].cityId == '0'
        ? SizedBox()
        : BlocBuilder<GetDistrictAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetDistrictSuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width,
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: districtValue,
                    hint: Text(
                      districtValue == null
                          ? listData[widget.data.index].districtId == '0'
                              ? "Pilih Kecamatan"
                              : listData[widget.data.index].district
                          : "Pilih Kecamatan",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        districtValue = value!;
                        listData[widget.data.index].district =
                            value.split("%")[1];
                        listData[widget.data.index].districtId =
                            value.split("%")[0];
                        villageValue = null;
                        getVillageBloc.add(GetDataVillageEvent(
                            listData[widget.data.index].districtId));
                      });
                    },
                    items: state.listDistrict.map((value) {
                      return DropdownMenuItem(
                        value: value.id.toString() + "%" + value.nama,
                        child: Text(
                          value.nama,
                          style: addAddressTextCategory,
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (state is GetDataError) {
                return Text(state.message.toString());
              } else if (state is GetDataAddressInitial) {
                return SizedBox();
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFF1A1A3F),
                      rightDotColor: const Color(0xFFEA3799),
                      size: 35,
                    ),
                  ),
                );
              }
            },
          );

    var villageAddress = listData.isEmpty ||
            listData[widget.data.index].districtId == '0'
        ? SizedBox()
        : BlocBuilder<GetVillageAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetVillageSuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width,
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 0,
                    ),
                    isExpanded: true,
                    value: villageValue,
                    hint: Text(
                      villageValue == null
                          ? listData[widget.data.index].villageId == '0'
                              ? "Pilih Kelurahan"
                              : listData[widget.data.index].village
                          : "Pilih Kelurahan",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        villageValue = value!;
                        listData[widget.data.index].village =
                            value.split("%")[1];
                        listData[widget.data.index].villageId =
                            value.split("%")[0];
                      });
                    },
                    items: state.listVillage.map((value) {
                      return DropdownMenuItem(
                        value: value.id.toString() + '%' + value.nama,
                        child: Text(
                          value.nama,
                          style: addAddressTextCategory,
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (state is GetDataError) {
                return Text(state.message.toString());
              } else if (state is GetDataAddressInitial) {
                return SizedBox();
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFF1A1A3F),
                      rightDotColor: const Color(0xFFEA3799),
                      size: 35,
                    ),
                  ),
                );
              }
            },
          );

    var postalCodeAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            width: _width / 2.5,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: DropdownButton<String>(
              underline: Container(
                height: 0,
              ),
              isExpanded: true,
              value: postalCodeValue,
              hint: Text(
                postalCodeValue == null
                    ? listData[widget.data.index].postalCode
                    : "Pilih Kode Pos",
                style: addAddressTextCategory,
              ),
              icon: const Icon(UniconsLine.angle_down),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  listData[widget.data.index].postalCode = value!;
                });
              },
              items:
                  listPostalCode.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: addAddressTextCategory,
                  ),
                );
              }).toList(),
            ),
          );

    var nameAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            width: _width,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: TextField(
              style: addAddressTextCategory,
              controller: nameAddressController,
              onChanged: (value) {
                listData[widget.data.index].addressName = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: nameAddressController.text == ""
                      ? listData[widget.data.index].addressName
                      : 'Nama Jalan',
                  hintStyle: addAddressTextCategory),
            ),
          );

    var rtddress = listData.isEmpty
        ? SizedBox()
        : Container(
            width: _width / 4.5,
            margin: EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: TextField(
              style: addAddressTextCategory,
              controller: rtAddressController,
              maxLength: 2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                listData[widget.data.index].rt = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: rtAddressController.text == ""
                      ? listData[widget.data.index].rt
                      : 'RT',
                  hintStyle: addAddressTextCategory),
            ),
          );

    var rwAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            width: _width / 4.5,
            margin: EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: TextField(
              style: addAddressTextCategory,
              controller: rwAddressController,
              maxLength: 2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                listData[widget.data.index].rw = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: rwAddressController.text == ""
                      ? listData[widget.data.index].rw
                      : 'RW',
                  hintStyle: addAddressTextCategory),
            ),
          );

    var phoneAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            width: _width,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: TextField(
              style: addAddressTextCategory,
              controller: phoneAddressController,
              maxLength: 2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                listData[widget.data.index].phoneNumber = value;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: phoneAddressController.text == ""
                      ? listData[widget.data.index].phoneNumber
                      : 'Nomor Telepon',
                  hintStyle: addAddressTextCategory),
            ),
          );

    var activeStatusAddress = listData.isEmpty
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    value: listData[widget.data.index].active,
                    onChanged: ((value) {
                      setState(() {
                        listData[widget.data.index].active = value!;
                      });
                    })),
                Text(
                  'Active',
                  style: addAddressTextCategory,
                )
              ],
            ),
          );

    var addAddressButton = BlocConsumer<AddressCubitCubit, AddressCubitState>(
      listener: (context, state) {
        if (state is SuccessAddData) {
          final snackBar = SnackBar(
            content: const Text('Berhasil Tambah Data!'),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.red,
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is LocalDataLoading) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFFEA3799),
                size: 35,
              ),
            ),
          );
        } else {
          return InkWell(
            onTap: () {
              if (listData[widget.data.index].cityId == "0" ||
                  listData[widget.data.index].districtId == "0" ||
                  listData[widget.data.index].villageId == "0" ||
                  listData[widget.data.index].rt == "" ||
                  listData[widget.data.index].rw == "" ||
                  listData[widget.data.index].phoneNumber == "") {
                final snackBar = SnackBar(
                  content: const Text('Lengkapi Data!'),
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.red,
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                context.read<AddressCubitCubit>().updateDataToLocal(listData);
              }
            },
            child: Container(
                width: _width,
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black87,
                    border: Border.all(width: 0.5, color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Center(
                  child: Text(
                    "Simpan Perubahan",
                    style: addAddressTextButton,
                  ),
                )),
          );
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: BlocListener<AddressCubitCubit, AddressCubitState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is LocalDataSuccess) {
              setState(() {
                listData = state.listData;
              });
            } else if (state is SuccessChangeData) {
              Navigator.pushNamed(context, '/');
            } else {
              setState(() {
                listData = [];
              });
            }
          },
          child: BlocBuilder<AddressCubitCubit, AddressCubitState>(
            builder: (context, state) {
              if (state is LocalDataSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(bottom: 20, left: 12, right: 12),
                          child: Row(
                            children: [
                              Text(
                                "Ubah Alamat",
                                style: homeTitleTextStyle,
                              )
                            ],
                          ),
                        ),
                        categoryAddress,
                        countryAddress,
                        provinceAddress,
                        cityAddress,
                        districtAddress,
                        villageAddress,
                        nameAddress,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [postalCodeAddress, rtddress, rwAddress],
                        ),
                        phoneAddress,
                        activeStatusAddress,
                        addAddressButton,
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFF1A1A3F),
                      rightDotColor: const Color(0xFFEA3799),
                      size: 35,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
