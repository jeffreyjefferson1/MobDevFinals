import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:todd_flutter_app/widgets/meal_card.dart';



class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  Future<void> callAPI() async {
    setState(() {
      meals = [];
    });
    for (int i = 0; i < 3; i++) {
      final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php"));

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        Meal randomMeal = Meal.fromJson(json['meals'][0]);
        print(response.body);
          setState(() {
          meals.add(randomMeal);
         });();
      } else {
        throw Exception('Failed to load meal');
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
           Padding(
             padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
             child: Center(
              child: Column(
                children: [
                  Text("Here is a set of randomized meals"),
                  Text("Click the refresh button to get a new set of meals")
                ],
              ),
             ),
           ),
           MealCard(meals: meals),
        ],
      ),
      
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 16.0), // Adjust the margin as needed
        child: FloatingActionButton.extended(
          onPressed: callAPI,
          heroTag: "btn1",
          icon: Icon(Icons.refresh),
          label: Text("Get More Recommendations"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      
    );
  }

  
}