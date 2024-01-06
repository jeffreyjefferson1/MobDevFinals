import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';

class MealsNotifier extends ValueNotifier<List<Meal>> {
  MealsNotifier(List<Meal> value) : super(value);

  void updateMeals(List<Meal> newMeals) {
    value = newMeals;
  }
}
