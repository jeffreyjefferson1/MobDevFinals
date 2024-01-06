import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';

class DetailsScreen extends StatelessWidget {
  final Meal meal;

  DetailsScreen({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.strMeal!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.strMealThumb!,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset('lib/assets/placeholderimg.png');
              },
            ),
            SizedBox(height: 16),
            Text(
              meal.strMeal!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Category: ${meal.strCategory!}'),
            Text('Area: ${meal.strArea!}'),
            SizedBox(height: 16),
            Text('Ingredients:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildIngredientsList(meal),
            ),
            SizedBox(height: 16),
            Text('Instructions:'),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(meal.strInstructions!),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList(Meal meal) {
    List<Widget> ingredientsList = [];
    for (int i = 0; i < meal.strIngredients!.length; i++) {
      String ingredient = meal.strIngredients![i]!;
      String measure = meal.strMeasures![i]!;
      ingredientsList.add(Text('$measure $ingredient'));
    }
    return ingredientsList;
  }
}