import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todd_flutter_app/models/meal.dart';
import 'package:todd_flutter_app/screens/add_screen.dart';
import 'package:todd_flutter_app/screens/details_screen.dart';
import 'package:todd_flutter_app/screens/settings_screen.dart';
import 'package:todd_flutter_app/screens/update_screen.dart';
import 'package:todd_flutter_app/utils/meal_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todd_flutter_app/utils/meals_notifier.dart';

class MealsScreen extends StatefulWidget {
  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  // List<Meal> meals =  MealList.instance.allMeals();
  List<Meal> meals =  [];
  late MealsNotifier mealsNotifier;

  void refresh() {
    // setState(() {
    //   meals = MealList.instance.allMeals();
    // });
    print(meals);

  }

  void removeMealFromFirestore(String? firestoreId) async {
    CollectionReference mealsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('meals');

    mealsCollection.doc(firestoreId).delete().then((_) {
      print("Meal removed from Firestore!");
    }).catchError((error) {
      print("Error removing meal: $error");
    });
  }

      // Assuming you have the user reference available
      User? user = FirebaseAuth.instance.currentUser;
      late StreamSubscription<QuerySnapshot> mealsSubscription;

      @override
      void initState() {
        super.initState();
        mealsNotifier = MealsNotifier(meals);
        if (user != null) {
          listenToMeals();
        }
  }

  void listenToMeals() {
  CollectionReference mealsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('meals');

  mealsSubscription = mealsCollection.snapshots().listen((QuerySnapshot querySnapshot) {
    List<Meal> temp = List.from(meals); // Create a copy of meals

    querySnapshot.docChanges.forEach((change) {
      if (change.type == DocumentChangeType.added) {
        print(change.doc.data());
        Meal meal = Meal.fromJson(change.doc.data() as Map<String, dynamic>, firestoreId: change.doc.id);
        // Do something with the added meal
        temp.add(meal); // Add the new meal to the copied list
      } else if (change.type == DocumentChangeType.modified) {
        Meal meal = Meal.fromJson(change.doc.data() as Map<String, dynamic>, firestoreId: change.doc.id);
        // Do something with the modified meal
        int index = temp.indexWhere((element) => element.idMeal == meal.idMeal);
        if (index != -1) {
          temp[index] = meal; // Update the modified meal in the copied list
        }
      } else if (change.type == DocumentChangeType.removed) {
        // Remove the meal from the copied list
        temp.removeWhere((element) => element.firestoreId == change.doc.id);
      }
    });

    setState(() {
      meals = temp;
      mealsNotifier.updateMeals(meals);
    });
  });
}


  @override
  void dispose() {
    mealsSubscription.cancel(); // Cancel the subscription to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
             padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
             child: Center(
              child: Column(
                children: [
                  Text("Here are your recipes"),
                ],
              ),
             ),
           ),
          Expanded(
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
                          child: ValueListenableBuilder<List<Meal>>(
                          valueListenable: mealsNotifier,
                          builder: (context, meals, _) {
                            return Column(
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
                            );
                          }),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateScreen(meal: meals[index]),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              removeMealFromFirestore(meals[index].firestoreId);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          ],
                        ),
                       
                      ],
                    ),
                  ),
                );
              },
              itemCount: meals.length,
            ),
          ),
          SizedBox(width: 16, height: 32,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.pushNamed(context, AddScreen.routeName);},
        heroTag: "btn2",
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}