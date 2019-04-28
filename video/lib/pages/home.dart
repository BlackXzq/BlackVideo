import 'package:flutter/material.dart';
import '../components/components.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Text("HomePage"),
      ),
      bottomNavigationBar: BLTabBar(tabIndex: 0),
    );
  }
}
