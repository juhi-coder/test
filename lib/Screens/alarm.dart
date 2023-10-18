import 'package:flutter/material.dart';

class Alarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('alarm'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("Alarm............"),
      ),
    );
  }
}
