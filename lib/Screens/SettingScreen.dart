import 'package:flutter/material.dart';
import 'package:test/db_helper.dart';
import 'package:test/ui/views/home/home_screen.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create an instance of HomeScreen

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

  static Future<void> deleteAllDatas() async {
    final db = await SQLHelper.db();
    await db.delete('data');
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
                deleteAllDatas(); // Call the instance method
              },
            ),
          ],
        );
      },
    );
  }
}
