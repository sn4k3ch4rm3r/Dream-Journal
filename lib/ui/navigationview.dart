import 'package:flutter/material.dart';

import 'analytics.dart';
import 'dream_list.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({ Key key }) : super(key: key);

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int selectedPage = 0;
  List<Widget> pages = [
    DreamList(),
    AnalyticsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage,
        animationDuration: Duration(milliseconds: 500),
        onDestinationSelected: (index) => setState(() => selectedPage = index),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.nights_stay_outlined),
            selectedIcon: Icon(Icons.nights_stay),
            label: 'Dreams',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined),
            selectedIcon: Icon(Icons.insert_chart),
            label: 'Analytics',
          )
        ]
      ),
    );
  }
}