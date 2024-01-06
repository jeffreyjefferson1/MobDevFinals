import 'package:flutter/material.dart';
import 'package:todd_flutter_app/screens/details_screen.dart';
import 'package:todd_flutter_app/utils/meal_list.dart';
import 'package:todd_flutter_app/models/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealCard extends StatelessWidget {
  MealCard({
    super.key,
    required this.meals,
  });

  final List<Meal> meals;

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> addMealToFirestore(int index) async {
    try {
      // Create a Firestore reference to the user's meals collection
      CollectionReference mealsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('meals');

      // Add the meal to Firestore
      await mealsCollection.add(meals[index].toMap());

      print('Meal added to Firestore successfully!');
    } catch (error) {
      // Handle errors here
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
     child: ListView.builder(
       itemBuilder: (BuildContext context, int index) {
         return GestureDetector(
           onTap: () {
             Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => DetailsScreen(meal: meals[index]),
             ),
           );
           },
           child: Container(
             margin: EdgeInsets.all(10),
             padding: EdgeInsets.all(10),
             decoration: BoxDecoration(
               border: Border.all(color: Colors.blue, width: 1),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                   height: 100,
                   width: 100,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     image: DecorationImage(
                       fit: BoxFit.cover,
                       image: NetworkImage(meals[index].strMealThumb!),
                     ),
                   ),
                 ),
                 SizedBox(width: 16,),
                 Expanded(
                   child: Container(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           meals[index].strMeal!,
                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                         ),
                         SizedBox(height: 8),
                         Text(
                           'Category: ${meals[index].strCategory!}',
                           style: TextStyle(fontSize: 14),
                         ),
                       ],
                     ),
                   ),
                 ),
                 
                 InkWell(
                   onTap: () {
                     addMealToFirestore(index);
                   },
                   child: Icon(
                     Icons.add,
                     color: Colors.black,
                   ),
                 ),
               ],
             ),
           ),
         );
       },
       itemCount: meals.length,
     ),
    );
  }
}