import 'package:flutter/material.dart';

class Likes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Likes'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Target more and more likes'),
      ),
    );
  }
}
