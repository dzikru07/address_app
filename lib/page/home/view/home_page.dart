// ignore_for_file: prefer_const_constructors

import 'package:address_app/page/address/view/add_address.dart';
import 'package:address_app/page/address/view/edit_address.dart';
import 'package:address_app/page/home/view/contoh_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicons/unicons.dart';
import '../../../style/color.dart';
import '../../../style/text.dart';
import '../../address/cubit/address_cubit_cubit.dart';

enum SampleItem { itemEdit, itemDelete, itemChangeStatus }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (context) => AddressCubitCubit(),
        child: HomePageBloc(),
      ),
    );
  }
}

class HomePageBloc extends StatefulWidget {
  const HomePageBloc({super.key});

  @override
  State<HomePageBloc> createState() => _HomePageBlocState();
}

class _HomePageBlocState extends State<HomePageBloc> {
  SampleItem? selectedMenu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddressCubitCubit>().getDataLocal();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Daftar Alamat',
                      style: homeTitleTextStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<AddressCubitCubit, AddressCubitState>(
                builder: (context, state) {
                  if (state is LocalDataSuccess) {
                    return ListView.builder(
                        itemCount:
                            state.listData.isEmpty ? 1 : state.listData.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (state.listData.isEmpty) {
                            return Container(
                              margin: EdgeInsets.only(top: 80),
                              child: Column(
                                children: [
                                  Icon(
                                    UniconsLine.annoyed_alt,
                                    size: 120,
                                    color: mainColor,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Alamat Kosong",
                                    style: listHomeTitleTextStyle,
                                  )
                                ],
                              ),
                            );
                          }
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: Duration(milliseconds: 100),
                              child: SlideAnimation(
                                  duration: Duration(milliseconds: 2500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                    duration: Duration(milliseconds: 2500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      margin: EdgeInsets.only(
                                          bottom: 10, left: 12, right: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 5,
                                              blurRadius: 20,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: _width / 1.4,
                                                child: Text(
                                                  state.listData[index]
                                                      .addressName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: listHomeTitleTextStyle,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              SizedBox(
                                                width: _width / 1.4,
                                                child: Text(
                                                  '${state.listData[index].province} ${state.listData[index].city} ${state.listData[index].district} ${state.listData[index].village}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style:
                                                      listHomeSubTitleTextStyle,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                'Kode Pos : ${state.listData[index].postalCode}',
                                                style:
                                                    listHomePostalCodeTextStyle,
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Status : ',
                                                    style:
                                                        listHomeStatusTextStyle,
                                                  ),
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: state
                                                                .listData[index]
                                                                .active
                                                            ? Colors.green
                                                            : Colors.grey),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          // InkWell(
                                          //     onTap: () {

                                          //     },
                                          //     child: Icon(UniconsLine.ellipsis_v))
                                          PopupMenuButton<SampleItem>(
                                            child: Container(
                                              height: 36,
                                              width: 48,
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.more_vert,
                                              ),
                                            ),
                                            // Callback that sets the selected popup menu item.
                                            itemBuilder: (BuildContext
                                                    context) =>
                                                <PopupMenuEntry<SampleItem>>[
                                              PopupMenuItem<SampleItem>(
                                                value: SampleItem.itemEdit,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            settings:
                                                                RouteSettings(
                                                              arguments:
                                                                  DataArguments(
                                                                      index,
                                                                      state.listData[
                                                                          index]),
                                                            ),
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return EditAddress();
                                                            }));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .edit_location_outlined,
                                                        color: Colors.black87,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text('Ubah Alamat'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem<SampleItem>(
                                                onTap: () {
                                                  setState(() {
                                                    state.listData
                                                        .removeAt(index);
                                                    context
                                                        .read<
                                                            AddressCubitCubit>()
                                                        .updateStatusDataToLocal(
                                                            state.listData);
                                                  });
                                                },
                                                value: SampleItem.itemDelete,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.redAccent,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text('Hapus Alamat'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<SampleItem>(
                                                onTap: () {
                                                  setState(() {
                                                    state.listData[index]
                                                            .active =
                                                        !state.listData[index]
                                                            .active;
                                                    context
                                                        .read<
                                                            AddressCubitCubit>()
                                                        .updateStatusDataToLocal(
                                                            state.listData);
                                                  });
                                                },
                                                value: SampleItem.itemEdit,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.change_circle,
                                                      color: state
                                                              .listData[index]
                                                              .active
                                                          ? Colors.grey
                                                          : Colors.green,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text('Ubah Status'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )));
                        });
                  } else {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 115),
                        child: LoadingAnimationWidget.twistingDots(
                          leftDotColor: const Color(0xFF1A1A3F),
                          rightDotColor: const Color(0xFFEA3799),
                          size: 35,
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
