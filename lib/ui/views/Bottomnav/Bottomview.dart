import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:test/ui/views/Bottomnav/Bottom_view_model.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        body: viewModel.getViewForIndex(viewModel.currentTabIndex),
        bottomNavigationBar: GestureDetector(
          onLongPress: () =>
              viewModel.showPopUpMenu(context, viewModel.currentTabIndex),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green,
            key:
                bottomNavBarKey, // Associate the GlobalKey with the BottomNavigationBar
            currentIndex: viewModel.currentTabIndex,
            onTap: viewModel.setTabIndex,
            items: viewModel.bottomNavBarItems,
          ),
        ),
      ),
      viewModelBuilder: () => BottomViewModel(),
    );
  }
}
