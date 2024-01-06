import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Description: Welcome to the Random Meal Generator app! This Flutter application provides you with a fun and easy way to discover new meals. Generate randomized meals along with recipes that you can follow to create delicious dishes. Whether you are a cooking enthusiast or just looking for culinary inspiration, this app has something for everyone.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Developer: Todd Josh Machacon',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}