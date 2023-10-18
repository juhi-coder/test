import 'package:flutter/material.dart';

class Face extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smile'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("Always smile"),
      ),
    );
  }
}
