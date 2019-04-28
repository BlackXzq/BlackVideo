import 'package:flutter/material.dart';

class Userpage extends StatefulWidget {
  final int userId;

  Userpage({
    Key key,
    @required this.userId
  }): super(key: key);

  @override
  _UserpageState createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
    );
  }
}
