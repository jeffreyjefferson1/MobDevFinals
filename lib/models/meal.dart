class Meal {
  String? idMeal;
  String? strMeal;
  String? strDrinkAlternate;
  String? strCategory;
  String? strArea;
  String? strInstructions;
  String? strMealThumb;
  String? strTags;
  String? strYoutube;
  List<String?>? strIngredients;
  List<String?>? strMeasures;
  String? strSource;
  String? strImageSource;
  String? strCreativeCommonsConfirmed;
  String? dateModified;
  String? firestoreId;

  Meal({
    this.idMeal,
    this.strMeal,
    this.strDrinkAlternate,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.strIngredients,
    this.strMeasures,
    this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
    this.firestoreId,
  });

  factory Meal.fromJson(var meal, {String? firestoreId}) {
    
    List<String?> ingredients = [];
    List<String?> measures = [];

    
      if(firestoreId == null) {
        for (int i = 1; i <= 20; i++) {
          if (meal['strIngredient$i'] != null && meal['strIngredient$i'] != "") {
            ingredients.add(meal['strIngredient$i']);
            measures.add(meal['strMeasure$i']);
          }
        }
      } else {
        for (var i = 0; i < meal['strIngredients'].length; i++) {
          ingredients.add(meal['strIngredients'][i]);
          measures.add(meal['strMeasures'][i]);
        }
      }

    return Meal(
      idMeal: meal['idMeal'],
      strMeal: meal['strMeal'],
      strDrinkAlternate: meal['strDrinkAlternate'],
      strCategory: meal['strCategory'],
      strArea: meal['strArea'],
      strInstructions: meal['strInstructions'],
      strMealThumb: meal['strMealThumb'],
      strTags: meal['strTags'],
      strYoutube: meal['strYoutube'],
      strIngredients: ingredients,
      strMeasures: measures,
      strSource: meal['strSource'],
      strImageSource: meal['strImageSource'],
      strCreativeCommonsConfirmed: meal['strCreativeCommonsConfirmed'],
      dateModified: meal['dateModified'],
      firestoreId: firestoreId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strDrinkAlternate': strDrinkAlternate,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'strIngredients': strIngredients,
      'strMeasures': strMeasures,
      'strSource': strSource,
      'strImageSource': strImageSource,
      'strCreativeCommonsConfirmed': strCreativeCommonsConfirmed,
      'dateModified': dateModified,
    };
  }
}