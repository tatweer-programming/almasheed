import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrdersScreen'),
      ),
      body: const Center(
        child: Text('OrdersScreen is working'),
      ),
    );
  }
}
