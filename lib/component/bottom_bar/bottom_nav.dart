import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../page/address/view/add_address.dart';
import '../../page/home/view/home_page.dart';
import '../../style/color.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  int pageIndex = 0;

  List page = [const HomePage(), const AddAddressPage()];

  late final AnimationController _controller;
  late final AnimationController _controller2;

  late Animation<double> animated;
  late Animation<double> animated2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    animated = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );
    animated2 = CurvedAnimation(
      parent: _controller2,
      curve: Curves.bounceOut,
    );
  }

  runAnimation() {
    _controller.repeat();
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: page[pageIndex],
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Container bottomNavBar(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: 60,
      child: Column(
        children: [
          Container(
            width: _width / 1.1,
            height: 0.3,
            color: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.only(bottom: 6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScaleTransition(
                scale: pageIndex == 0 ? animated : animated2,
                child: Container(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: pageIndex == 0
                          ? navBarActiveCOlor
                          : Colors.transparent),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          setState(() {
                            pageIndex = 0;
                            pageIndex == 0 ? runAnimation() : null;
                          });
                        });
                      },
                      icon: Icon(
                          pageIndex == 0
                              ? UniconsLine.list_ul
                              : UniconsLine.list_ol_alt,
                          size: 25,
                          color: pageIndex == 0
                              ? navBarActiveIcon
                              : navBarInActiveIcon)),
                ),
              ),
              ScaleTransition(
                scale: pageIndex == 1 ? animated : animated2,
                child: Container(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: pageIndex == 1
                          ? navBarActiveCOlor
                          : Colors.transparent),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          pageIndex = 1;
                          pageIndex == 1 ? runAnimation() : null;
                        });
                      },
                      icon: Icon(
                          pageIndex == 1
                              ? UniconsLine.plus
                              : UniconsLine.plus_square,
                          size: 25,
                          color: pageIndex == 1
                              ? navBarActiveIcon
                              : navBarInActiveIcon)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
