import 'package:flutter/material.dart';

class UiElements {
  static BottomNavigationBar bottomNavigator(context, {int selected = 0}) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_3),
          title: Text('Dreams')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.equalizer),
          title: Text('Analytics')
        ),
      ],
      currentIndex: selected,
      selectedItemColor: Theme.of(context).accentColor,
      unselectedItemColor: Theme.of(context).textTheme.bodyText2.color,
    );
  }
}