import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrdersScreen'),
      ),
      body: Center(
        child: Text('OrdersScreen is working'),
      ),
    );
  }
}
