import 'dart:convert';

import 'package:address_app/page/home/model/list_models.dart';
import 'package:address_app/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetDataAddressBloc()..add(GetDataAddressEvent()),
          ),
          BlocProvider(
            create: (context) => GetCityAddressBloc(),
          ),
          BlocProvider(
            create: (context) => GetDistrictAddressBloc(),
          ),
          BlocProvider(
            create: (context) => GetVillageAddressBloc(),
          ),
          BlocProvider(
            create: (context) => AddressCubitCubit(),
          ),
        ],
        child: AddAddressPageBloc(),
      ),
    );
  }
}

class AddAddressPageBloc extends StatefulWidget {
  const AddAddressPageBloc({super.key});

  @override
  State<AddAddressPageBloc> createState() => _AddAddressPageBlocState();
}

class _AddAddressPageBlocState extends State<AddAddressPageBloc> {
  var categoryValue = listCategory.first;
  var countryValue = listCountry.first;
  var provinceValue, cityValue, districtValue, villageValue, postalCodeValue;
  var provinceValueName, cityValueName, districtValueName, villageValueName;
  var provinceValueId, cityValueId, districtValueId, villageValueId;

  bool activeStatus = false;

  //text Controller
  TextEditingController nameAddressController = TextEditingController();
  TextEditingController rtAddressController = TextEditingController();
  TextEditingController rwAddressController = TextEditingController();
  TextEditingController phoneAddressController = TextEditingController();

  //loading
  bool addLoadingSession = false;

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
    AddressCubitCubit localDataCubit = context.read<AddressCubitCubit>();

    double _width = MediaQuery.of(context).size.width;

    categoryAddress(double sizeWidth) => Container(
          margin: EdgeInsets.only(bottom: 10),
          width: _width / sizeWidth,
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
            value: categoryValue,
            icon: const Icon(UniconsLine.angle_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                categoryValue = value!;
                print(categoryValue);
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

    countryAddress(double sizeWidth) => Container(
          margin: EdgeInsets.only(bottom: 10),
          width: _width / sizeWidth,
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
            value: countryValue,
            icon: const Icon(UniconsLine.angle_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                countryValue = value!;
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

    provinceAddress(double sizeWidth) =>
        BlocBuilder<GetDataAddressBloc, GetDataAddressState>(
          builder: (context, state) {
            if (state is GetProviceSuccess) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                width: _width / sizeWidth,
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
                    "Pilih Provisi",
                    style: addAddressTextCategory,
                  ),
                  icon: const Icon(UniconsLine.angle_down),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (value) {
                    // This is called when the user selects an item.
                    setState(() {
                      provinceValue = value;
                      cityValue = null;
                      districtValue = null;
                      villageValue = null;
                      provinceValueId = provinceValue.toString().split("/")[0];
                      provinceValueName =
                          provinceValue.toString().split("/")[1];
                      getCityBloc.add(GetDataCityEvent(provinceValueId));
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

    cityAddress(double sizeWidth) => provinceValue == null
        ? SizedBox()
        : BlocBuilder<GetCityAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetCitySuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width / sizeWidth,
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
                      "Pilih Kota",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        cityValue = value!;
                        districtValue = null;
                        villageValue = null;
                        cityValueId = value.split("%")[0];
                        cityValueName = value.split("%")[1];
                        getDistrictBloc.add(GetDataDistrictEvent(cityValueId));
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

    districtAddress(double sizeWidth) => cityValue == null
        ? SizedBox()
        : BlocBuilder<GetDistrictAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetDistrictSuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width / sizeWidth,
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
                      "Pilih Kecamatan",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        districtValue = value!;
                        villageValue = null;
                        districtValueId = value.split("%")[0];
                        districtValueName = value.split("%")[1];
                        getVillageBloc
                            .add(GetDataVillageEvent(districtValueId));
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

    villageAddress(double sizeWidth) => districtValue == null
        ? SizedBox()
        : BlocBuilder<GetVillageAddressBloc, GetDataAddressState>(
            builder: (context, state) {
              if (state is GetVillageSuccess) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: _width / sizeWidth,
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
                      "Pilih Kelurahan",
                      style: addAddressTextCategory,
                    ),
                    icon: const Icon(UniconsLine.angle_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        villageValue = value!;
                        villageValueId = value.split("%")[0];
                        villageValueName = value.split("%")[1];
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

    postalCodeAddress(double sizeWidth) => Container(
          margin: EdgeInsets.only(bottom: 10),
          width: _width / sizeWidth,
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
              "Pilih Kode Pos",
              style: addAddressTextCategory,
            ),
            icon: const Icon(UniconsLine.angle_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                postalCodeValue = value!;
              });
            },
            items: listPostalCode.map<DropdownMenuItem<String>>((String value) {
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

    nameAddress(double sizeWidth) => Container(
          margin: EdgeInsets.only(bottom: 10),
          width: _width / sizeWidth,
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
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nama Jalan',
                hintStyle: addAddressTextCategory),
          ),
        );

    rtddress(double sizeWidth) => Container(
          width: _width / sizeWidth,
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
            maxLength: 3,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: 'RT',
                hintStyle: addAddressTextCategory),
          ),
        );

    rwAddress(double sizeWidth) => Container(
          width: _width / sizeWidth,
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
            decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: 'RW',
                hintStyle: addAddressTextCategory),
          ),
        );

    phoneAddress(double sizeWidth) => Container(
          width: _width / sizeWidth,
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
            controller: phoneAddressController,
            maxLength: 13,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: 'Nomor Telepon',
                hintStyle: addAddressTextCategory),
          ),
        );

    var activeStatusAddress = Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
              value: activeStatus,
              onChanged: ((value) {
                setState(() {
                  activeStatus = value!;
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

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
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
          return ResponsiveBuilder(builder: (context, sizingInformation) {
            return SizedBox(
              width: sizingInformation.deviceScreenType ==
                          DeviceScreenType.mobile ||
                      sizingInformation.deviceScreenType ==
                          DeviceScreenType.tablet
                  ? _width / 1.07
                  : _width / 5,
              child: InkWell(
                onTap: () {
                  if (provinceValueName == null ||
                      cityValueName == null ||
                      districtValueName == null ||
                      villageValueName == null ||
                      nameAddressController.text == "" ||
                      rtAddressController.text == "" ||
                      rwAddressController.text == "" ||
                      phoneAddressController.text == "") {
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
                    localDataCubit.addDataToLocal(AddressModels(
                        category: categoryValue,
                        country: countryValue,
                        province: provinceValueName,
                        city: cityValueName,
                        district: districtValueName,
                        village: villageValueName,
                        postalCode: postalCodeValue,
                        addressName: nameAddressController.text,
                        rt: rtAddressController.text,
                        rw: rwAddressController.text,
                        phoneNumber: phoneAddressController.text,
                        active: activeStatus,
                        provinceId: provinceValueId,
                        cityId: cityValueId,
                        districtId: districtValueId,
                        villageId: villageValueId));
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

                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                      child: Text(
                        "Simpan Alamat",
                        style: addAddressTextButton,
                      ),
                    )),
              ),
            );
          });
        }
      },
    );

    return ResponsiveBuilder(builder: (context, sizeInformation) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: bgColor,
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
                    child: Row(
                      children: [
                        Text(
                          "Tambah Alamat",
                          style: homeTitleTextStyle,
                        )
                      ],
                    ),
                  ),
                  sizeInformation.deviceScreenType == DeviceScreenType.mobile ||
                          sizeInformation.deviceScreenType ==
                              DeviceScreenType.tablet
                      ? Column(
                          children: [
                            categoryAddress(1),
                            countryAddress(1),
                            provinceAddress(1),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            categoryAddress(3.8),
                            countryAddress(3.8),
                            provinceAddress(2.5),
                          ],
                        ),
                  sizeInformation.deviceScreenType == DeviceScreenType.mobile ||
                          sizeInformation.deviceScreenType ==
                              DeviceScreenType.tablet
                      ? Column(
                          children: [
                            cityAddress(1),
                            districtAddress(1),
                            villageAddress(1),
                            nameAddress(1)
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cityAddress(3.8),
                            districtAddress(3.8),
                            villageAddress(2.5),
                          ],
                        ),

                  sizeInformation.deviceScreenType == DeviceScreenType.mobile ||
                          sizeInformation.deviceScreenType ==
                              DeviceScreenType.tablet
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            postalCodeAddress(2.5),
                            rtddress(4.5),
                            rwAddress(4.5),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            postalCodeAddress(4),
                            rtddress(6),
                            rwAddress(6),
                            phoneAddress(3)
                          ],
                        ),
                  // phoneAddress,
                  sizeInformation.deviceScreenType == DeviceScreenType.mobile ||
                          sizeInformation.deviceScreenType ==
                              DeviceScreenType.tablet
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            phoneAddress(1.035),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            nameAddress(2),
                          ],
                        ),
                  activeStatusAddress,
                  addLoadingSession
                      ? CircularProgressIndicator(
                          color: Colors.black87,
                        )
                      : Row(
                          mainAxisAlignment: sizeInformation.deviceScreenType ==
                                      DeviceScreenType.tablet ||
                                  sizeInformation.deviceScreenType ==
                                      DeviceScreenType.tablet
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            addAddressButton,
                          ],
                        ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
