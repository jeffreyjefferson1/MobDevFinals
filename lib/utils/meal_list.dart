import 'package:todd_flutter_app/models/meal.dart';

class MealList {
  MealList._privateConstructor();

  static final MealList _instance = MealList._privateConstructor();

  static MealList get instance => _instance;

  List<Meal> meals = [];

  List<Meal> allMeals() {
    return meals;
  }

  void addMeal(Meal meal) {
    meals.add(meal);
  }

  void removeMeal(Meal meal) {
    meals.remove(meal);
  }

  void emptyMeal() {
    meals = [];
  }

  bool isMeal(Meal meal) {
    return meals.contains(meal);
  }
}