import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  static const String routeName = "placeholder";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Placeholder"),
      ),
      body: Center(
        child: Text("This is a placeholder screen"),
      ),
    );
  }
}
