import 'package:flutter/material.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FavouritesScreen'),
      ),
      body: Center(
        child: Text('FavouritesScreen is working'),
      ),
    );
  }
}
