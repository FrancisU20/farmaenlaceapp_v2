import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:farmaenlaceapp/pages/home/profile_page.dart';
import 'package:farmaenlaceapp/pages/traspasos/traspasos_recepcion.dart';
import 'package:farmaenlaceapp/pages/traspasos/traspasos_transito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmaenlaceapp/theme/colors.dart';

class FarmarecepcionDashboard extends StatefulWidget {
  const FarmarecepcionDashboard({super.key});

  @override
  State<FarmarecepcionDashboard> createState() => _FarmarecepcionDashboard();
}

class _FarmarecepcionDashboard extends State<FarmarecepcionDashboard> {
  int pageIndex = 0;

  List<Widget> pages = [
    const TraspasosTransito(),
    const TraspasosRecepcion(),
    const ProfilePage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: SafeArea(
        child: SizedBox(
          // height: 30,
          // width: 40,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            backgroundColor: buttoncolor,
            child: const Icon(
              Icons.home,
              size: 20,
            ),
            // shape:
            //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      CupertinoIcons.cube_box,
      CupertinoIcons.check_mark_circled,
      CupertinoIcons.archivebox,
      CupertinoIcons.person,
    ];
    return AnimatedBottomNavigationBar(
        backgroundColor: primary,
        icons: iconItems,
        splashColor: secondary,
        inactiveColor: black.withOpacity(0.5),
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 2,
        onTap: (index) {
          setTabs(index);
        });
  }

  setTabs(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
