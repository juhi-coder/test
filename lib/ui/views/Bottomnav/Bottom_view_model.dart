import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:stacked/stacked.dart';
import 'package:test/Screens/Face.dart';
import 'package:test/Screens/Likes.dart';
import 'package:test/Screens/Search.dart';
import 'package:test/Screens/Setting.dart';
import 'package:test/Screens/ShoppingCart.dart';
import 'package:test/Screens/abc.dart';
import 'package:test/Screens/alarm.dart';
import 'package:test/ui/views/home/home_view.dart';

class BottomViewModel extends IndexTrackingViewModel {
  int currentTabIndex = 0;
  final _bottomnavdata = Hive.box('bottomnav_data');

  void setTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  List<Widget> allViews = [
    Home(),
    Likes(),
    Search(),
    Setting(),
    Face(),
    ShoppingCart(),
    Alarm(),
    Abc()
  ];

  List<Widget> viewsList = [
    Home(),
    Likes(),
    Search(),
    Setting(),
  ];

  final List<IconData> originalView = [
    Icons.home,
    Icons.favorite_border_outlined,
    Icons.search,
    Icons.settings,
  ];

  List<Widget> bottomList = [Face(), ShoppingCart(), Alarm(), Abc()];

  List<IconData> popupMenuItems = [
    Icons.face,
    Icons.add_shopping_cart,
    Icons.access_alarm_rounded,
    Icons.abc,
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      label: '', // Empty string as label
      icon: Icon(Icons.home),
    ),
    const BottomNavigationBarItem(
      label: '', // Empty string as label
      icon: Icon(Icons.favorite_border_outlined),
    ),
    const BottomNavigationBarItem(
      label: '', // Empty string as label
      icon: Icon(Icons.search),
    ),
    const BottomNavigationBarItem(
      label: '', // Empty string as label
      icon: Icon(Icons.settings),
    ),
  ];

  // Track selected icons in the bottom nav
  List<IconData> selectedIcons = [];
  List<IconData> longpressedIcons = [];

  final int homeOriginalIndex = 0;
  final int likesOriginalIndex = 1;
  final int searchOriginalIndex = 2;
  final int settingsOriginalIndex = 3;

  final int faceOriginalIndex = 0;
  final int shoppingOriginalIndex = 1;
  final int alarmOriginalIndex = 2;
  final int abcOriginalIndex = 3;

  Widget getViewForIndex(int index) {
    return viewsList[index];
  }

  void showPopUpMenu(BuildContext context, int current_index) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox button =
        bottomNavBarKey.currentContext!.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);

    final iconCount =
        bottomNavBarItems.length; // Number of icons in the bottom nav
    final iconWidth = button.size.width / iconCount; // Width of each icon
    final selectedIconPositionX = position.dx +
        (iconWidth * current_index); // X-coordinate of the selected icon

    final selectedValue = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        selectedIconPositionX, // X-coordinate of the selected icon
        position.dy -
            230.0, // Adjust this value as needed for vertical positioning
        selectedIconPositionX +
            iconWidth, // X-coordinate of the right edge of the selected icon
        position.dy +
            button.size.height +
            10.0, // Y-coordinate of the bottom edge of the icon
      ),
      items: popupMenuItems.asMap().entries.map((entry) {
        final index = entry.key;
        final icon = entry.value;
        return PopupMenuItem<int>(
          child: Icon(icon, size: 24.0),
          value: index,
        );
      }).toList(),
    );
    if (selectedValue != null) {
      final selectedIconData = popupMenuItems[selectedValue];
      final longPressedIconData = bottomNavBarItems[current_index];
      // Check if the selected icon is already in the bottom nav
      if (longPressedIconData != selectedIconData) {
        // Update the view
        if (originalView.contains(selectedIconData)) {
          if (selectedIconData == Icons.home) {
            viewsList[current_index] = allViews[homeOriginalIndex];
          } else if (selectedIconData == Icons.favorite_border_outlined) {
            viewsList[current_index] = allViews[likesOriginalIndex];
          } else if (selectedIconData == Icons.search) {
            viewsList[current_index] = allViews[searchOriginalIndex];
          } else if (selectedIconData == Icons.settings) {
            viewsList[current_index] = allViews[settingsOriginalIndex];
          }
        } else {
          if (selectedIconData == Icons.face) {
            viewsList[current_index] = bottomList[faceOriginalIndex];
          } else if (selectedIconData == Icons.add_shopping_cart) {
            viewsList[current_index] = bottomList[shoppingOriginalIndex];
          } else if (selectedIconData == Icons.access_alarm_rounded) {
            viewsList[current_index] = bottomList[alarmOriginalIndex];
          } else if (selectedIconData == Icons.abc) {
            viewsList[current_index] = bottomList[abcOriginalIndex];
          }
        }

        // Update the bottom nav item
        bottomNavBarItems[current_index] = BottomNavigationBarItem(
          label: '', // Empty string as label
          icon: Icon(selectedIconData),
        );
        // Add the selected icon to the tracked list
        selectedIcons.add(selectedIconData);

        // Remove the selected icon from popupMenuItems
        popupMenuItems.removeAt(selectedValue);
        popupMenuItems.add((longPressedIconData.icon as Icon).icon!);

        notifyListeners();
      }
    }
  }
}

final GlobalKey bottomNavBarKey = GlobalKey();
