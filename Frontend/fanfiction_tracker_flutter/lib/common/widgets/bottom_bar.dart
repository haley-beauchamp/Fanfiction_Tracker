import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/account/screens/account_screen.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/home_screen.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/lists_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  final int initialPage;

  const BottomBar({super.key, required this.initialPage});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomNavigationBarWidth = 42;
  double bottomNavigationBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const ListsScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavigationBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavigationBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.library_books_outlined,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomNavigationBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomNavigationBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
