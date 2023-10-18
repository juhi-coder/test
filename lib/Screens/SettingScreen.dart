import 'package:flutter/material.dart';
import 'package:test/ui/views/home/home_viewmodel.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen(this.viewModel, {super.key});
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: () {
              deleteAllData(context);
            },
            child: const Text('Delete All Data')),
      ),
      // bottomNavigationBar: BottomNavigation(),
    );
  }

  void deleteAllData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Data'),
          content: const Text('Are You Sure Want To Delete All Data?'),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.deleteAllItems();
              },
            ),
          ],
        );
      },
    );
  }
}
