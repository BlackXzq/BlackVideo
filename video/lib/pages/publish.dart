import 'package:flutter/material.dart';
import '../components/components.dart';

class PublishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Page'),
      ),
      body: Center(
        child: Text("PublishPage"),
      ),
      bottomNavigationBar: BLTabBar(tabIndex: 1),
    );
  }
}
