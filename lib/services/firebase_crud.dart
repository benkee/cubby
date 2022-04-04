import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/food_item.dart';
import '../models/recipe.dart';

// ignore: camel_case_types
class FirebaseCRUD {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String userID =
      FirebaseAuth.instance.currentUser?.uid.toString() ?? '';
  static String userFoodItems = userID + 'FoodItem';
  static String userRecipes = userID + 'Recipes';

  static void addFoodItem(FoodItem foodItem) {
    firestore
        .collection(userFoodItems)
        .add(foodItem.toJson())
        .then((value) => foodItem.setID(value.id));
  }

  static Future<List<FoodItem>> getFoodItems() async {
    List<FoodItem> foodItems = [];
    await firestore.collection(userFoodItems).get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        FoodItem foodItem = FoodItem.fromJson(document.data());
        foodItems.add(foodItem);
        foodItem.setID(document.id.toString());
      }
    });
    return foodItems;
  }

  static void deleteFoodItem(FoodItem foodItem) {
    firestore.collection(userFoodItems).doc(foodItem.id).delete();
  }

  static void updateFoodItem(FoodItem foodItem, String field, dynamic value) {
    firestore.collection(userFoodItems).doc(foodItem.id).update({field: value});
  }

  static Future<List<Recipe>> getRecipes() async {
    List<Recipe> recipes = [];
    await firestore.collection(userRecipes).get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        Recipe recipe = Recipe.fromJson(document.data());
        recipes.add(recipe);
        recipe.setID(document.id.toString());
      }
    });
    return recipes;
  }

  static void addRecipe(Recipe recipe) {
    firestore
        .collection(userRecipes)
        .add(recipe.toJson())
        .then((value) => recipe.setID(value.id));
  }
}
