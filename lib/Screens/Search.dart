import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Searching'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Seraching Something...........'),
      ),
    );
  }
}
