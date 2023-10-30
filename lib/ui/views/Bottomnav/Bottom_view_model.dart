import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test/Screens/Face.dart';
import 'package:test/Screens/Likes.dart';
import 'package:test/Screens/Search.dart';
import 'package:test/Screens/Setting.dart';
import 'package:test/Screens/SettingScreen.dart';
import 'package:test/Screens/ShoppingCart.dart';
import 'package:test/Screens/abc.dart';
import 'package:test/Screens/alarm.dart';
import 'package:test/ui/views/home/home_screen.dart';

class BottomViewModel extends IndexTrackingViewModel {
  int currentTabIndex = 0;

  void setTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  List<Widget> allViews = [
    HomeScreen(),
    Likes(),
    Search(),
    Setting(),
    Face(),
    ShoppingCart(),
    Alarm(),
    Abc(),
    SettingScreen()
  ];

  List<Widget> viewsList = [
    HomeScreen(),
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

  final Map<IconData, int> originalViewIndexes = {
    Icons.home: 0,
    Icons.favorite_border_outlined: 1,
    Icons.search: 2,
    Icons.settings: 3,
  };

  final Map<IconData, int> bottomListIndexes = {
    Icons.face: 0,
    Icons.add_shopping_cart: 1,
    Icons.access_alarm_rounded: 2,
    Icons.abc: 3,
  };

  List<IconData> popupMenuItems = [
    Icons.face,
    Icons.add_shopping_cart,
    Icons.access_alarm_rounded,
    Icons.abc,
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.home),
    ),
    const BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.favorite_border_outlined),
    ),
    const BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.search),
    ),
    const BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.settings),
    ),
  ];

  // Track selected icons in the bottom nav
  List<IconData> selectedIcons = [];
  List<IconData> longpressedIcons = [];

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
      final longPressedIconData = bottomNavBarItems[current_index].icon as Icon;

      final originalViewIndex = originalViewIndexes[selectedIconData];
      final bottomListIndex = bottomListIndexes[selectedIconData];

      if (originalViewIndex != null) {
        viewsList[current_index] = allViews[originalViewIndex];
      } else if (bottomListIndex != null) {
        viewsList[current_index] = bottomList[bottomListIndex];
      }

      bottomNavBarItems[current_index] = BottomNavigationBarItem(
        label: '',
        icon: Icon(selectedIconData),
      );

      selectedIcons.add(selectedIconData);
      popupMenuItems.removeAt(selectedValue);
      popupMenuItems.add(longPressedIconData.icon!);

      notifyListeners();
    }
  }
}

final GlobalKey bottomNavBarKey = GlobalKey();
