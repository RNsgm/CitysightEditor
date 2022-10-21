import 'package:citysight_editor/fragments/HomeFragment.dart';
import 'package:citysight_editor/fragments/MapFragment.dart';
import 'package:citysight_editor/fragments/ProfileFragment.dart';
import 'package:citysight_editor/ui/MapboxWidget.dart';
import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/ui/AppPanel.dart';
import 'package:citysight_editor/ui/Body.dart';
import 'package:citysight_editor/utils/SystemPrefs.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isAuthorized = false;
  bool isEditorPerm = false;

  final SystemPrefs _prefs = SystemPrefs();

  final List<Widget> _widgetOptions = <Widget>[
    HomeFragment(),
    MapFragment(),
    ProfileFragment(),
  ];

  final List<BottomNavigationBarItem> _bottomItemsAuthorized =
      <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded), label: "Главная"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.map_rounded), label: "Карта"),
    // const BottomNavigationBarItem(
    //     icon: Icon(Icons.map_rounded), label: "Test"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль")
  ];
  final List<BottomNavigationBarItem> _bottomItemsNonAuthorized =
      <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded), label: "Главная"),
    const BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: "Карта")
  ];

  @override
  void initState() {
    _prefs.getAuthToken().then((value) => {
          if (value != "")
            {
              setState(() {
                isAuthorized = true;
              })
            }
        });
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 4) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Editor()));
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      login: !isAuthorized,
      isShowActions: !isAuthorized,
      body: Container(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: _widgetOptions[_selectedIndex]),
      bottomNavigation: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          items: isAuthorized
              ? _bottomItemsAuthorized
              : _bottomItemsNonAuthorized),
    );
  }
}
