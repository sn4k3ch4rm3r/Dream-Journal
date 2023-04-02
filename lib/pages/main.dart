import 'package:flutter/material.dart';

import 'analytics/analytics_view.dart';
import 'dream_list/dream_list_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int selectedPage = 0;
  List<Widget> pages = [
    const DreamList(),
    const AnalyticsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage,
        height: 65,
        onDestinationSelected: (index) => setState(
          () => selectedPage = index,
        ),
        destinations: const [
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
        ],
      ),
    );
  }
}
