import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/views/overview.dart';
import 'package:clinicpro/views/search.dart';
import 'package:clinicpro/views/add_patient.dart';
import 'package:clinicpro/utilities/iconly_bold.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Overview(),
    const Search(),
    const AddPatient(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.backgroundColor,
        title: Text(
          (_selectedIndex == 0)
              ? 'Overview'
              : ((_selectedIndex == 1) ? 'Search' : 'Add Patient'),
          style: TextStyle(
            color: Styles.blackColor,
          ),
        ),
        actions: const <Widget>[],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Styles.primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 20, color: Styles.primaryColor),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Styles.whiteColor,
        unselectedItemColor: Styles.darkGreyColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Home),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Plus),
            label: 'Add Patient',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
