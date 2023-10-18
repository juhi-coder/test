import 'package:flutter/material.dart';

class Abc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('abc'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("ABC..................."),
      ),
    );
  }
}
