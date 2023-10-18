import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Likes.dart';
import 'Search.dart';
import 'Setting.dart';

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("Shopping........................."),
      ),
    );
  }
}
