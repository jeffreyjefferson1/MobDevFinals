import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  static const String routeName = "add";

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _measurementControllers = [];

  @override
  void initState() {
    super.initState();
    _ingredientControllers.add(TextEditingController());
    _measurementControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _ingredientControllers.forEach((controller) => controller.dispose());
    _measurementControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _addMeal() async {
    List<String?> ingredients = _ingredientControllers.map((controller) => controller.text).toList();
    List<String?> measures = _measurementControllers.map((controller) => controller.text).toList();

    Meal newMeal = Meal(
      strMeal: _mealNameController.text,
      strCategory: _categoryController.text,
      strArea: _areaController.text,
      strInstructions: _instructionsController.text,
      strIngredients: ingredients,
      strMeasures: measures,
      strMealThumb: 'https://rebelnation1.s3.amazonaws.com/wp-content/uploads/2017/06/wsi-imageoptim-placeholder-700x700.jpg',
    );

    CollectionReference instance = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('meals');

    try {
      await instance.add(newMeal.toMap());
      Navigator.pop(context);
    } catch (e) {
      print("Error adding meal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _mealNameController,
              decoration: InputDecoration(
                labelText: 'Meal Name',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: 'Area',
              ),
            ),
            SizedBox(height: 12.0),
            Column(
              children: _buildIngredientFields(),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _instructionsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Instructions',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _addMeal,
              child: Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredientFields() {
    List<Widget> fields = [];

    for (int i = 0; i < _ingredientControllers.length; i++) {
      fields.add(Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _measurementControllers[i],
              decoration: InputDecoration(
                labelText: 'Measurement',
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            flex: 5,
            child: TextField(
              controller: _ingredientControllers[i],
              decoration: InputDecoration(
                labelText: 'Ingredient',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _ingredientControllers.add(TextEditingController());
                _measurementControllers.add(TextEditingController());
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                if (_ingredientControllers.length > 1) {
                  _ingredientControllers.removeLast().dispose();
                  _measurementControllers.removeLast().dispose();
                }
              });
            },
          ),
        ],
      ));
    }
    return fields;
  }
}
