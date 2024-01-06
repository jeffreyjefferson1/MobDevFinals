import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';
import 'package:http/http.dart' as http;
import 'package:todd_flutter_app/widgets/meal_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Meal> _searchResults = [];

  Future<void> _performSearch(String query) async {
    
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=$query"));
    response;
    if (response.statusCode == 200) {
      List<Meal> filteredResults = [];
      var json = jsonDecode(response.body);
      if(json["meals"] == null) { // empty search results
        setState(() {
          _searchResults = [];
        });();
      } else {
        json["meals"].forEach((meal) {
          filteredResults.add(Meal.fromJson(meal));
        });
        setState(() {
          _searchResults = filteredResults;
        });();
      }
    } else {
      throw Exception('Failed to load meal');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _performSearch(_searchController.text);
                },
              ),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _performSearch(value);
            },
          ),
        ),
        MealCard(meals: _searchResults),
      ],
    );
  }
}