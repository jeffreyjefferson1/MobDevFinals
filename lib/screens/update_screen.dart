import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateScreen extends StatefulWidget {
  static const String routeName = "update";

  final Meal meal;

  UpdateScreen({required this.meal});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController _mealNameController;
  late TextEditingController _categoryController;
  late TextEditingController _areaController;
  late TextEditingController _instructionsController;
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _measurementControllers = [];

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController(text: widget.meal.strMeal);
    _categoryController = TextEditingController(text: widget.meal.strCategory);
    _areaController = TextEditingController(text: widget.meal.strArea);
    _instructionsController = TextEditingController(text: widget.meal.strInstructions);

    widget.meal.strIngredients!.forEach((ingredient) {
      _ingredientControllers.add(TextEditingController(text: ingredient));
    });

    widget.meal.strMeasures!.forEach((measure) {
      _measurementControllers.add(TextEditingController(text: measure));
    });
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _categoryController.dispose();
    _areaController.dispose();
    _instructionsController.dispose();
    _ingredientControllers.forEach((controller) => controller.dispose());
    _measurementControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _updateMeal() async {
    List<String?> ingredients = _ingredientControllers.map((controller) => controller.text).toList();
    List<String?> measures = _measurementControllers.map((controller) => controller.text).toList();

    Meal updatedMeal = Meal(
      idMeal: widget.meal.idMeal,
      strMeal: _mealNameController.text,
      strCategory: _categoryController.text,
      strArea: _areaController.text,
      strInstructions: _instructionsController.text,
      strIngredients: ingredients,
      strMeasures: measures,
      strMealThumb: widget.meal.strMealThumb, // Maintain the existing thumbnail or update if required
    );

    CollectionReference instance = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('meals');

    try {
      await instance.doc(widget.meal.firestoreId).update(updatedMeal.toMap());
      Navigator.pop(context);
    } catch (e) {
      print("Error updating meal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Meal'),
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
              onPressed: _updateMeal,
              child: Text('Update Meal'),
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
