import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cubby_user.dart';
import '../models/food_item.dart';
import '../models/recipe.dart';

// ignore: camel_case_types
class FirebaseCRUD {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void addFoodItem(FoodItem foodItem, String userID) async {
    firestore
        .collection(userID + 'FoodItem')
        .add(foodItem.toJson())
        .then((value) => foodItem.setID(value.id));
  }

  static Future<List<FoodItem>> getFoodItems(String userID) async {
    List<FoodItem> foodItems = [];
    await firestore.collection(userID + 'FoodItem').get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        FoodItem foodItem = FoodItem.fromJson(document.data());
        foodItems.add(foodItem);
        foodItem.setID(document.id.toString());
      }
    });
    return foodItems;
  }

  static void deleteFoodItem(FoodItem foodItem, String userID) {
    firestore.collection(userID + 'FoodItem').doc(foodItem.id).delete();
  }

  static void updateFoodItem(
      FoodItem foodItem, String field, dynamic value, String userID) {
    firestore
        .collection(userID + 'FoodItem')
        .doc(foodItem.id)
        .update({field: value});
  }

  static void updateRecipe(
      Recipe recipe, String field, dynamic value, String userID) {
    firestore
        .collection(userID + 'Recipes')
        .doc(recipe.id)
        .update({field: value});
  }

  static Future<List<Recipe>> getRecipes(String userID) async {
    List<Recipe> recipes = [];
    await firestore.collection(userID + 'Recipes').get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        Recipe recipe = Recipe.fromJson(document.data());
        recipes.add(recipe);
        recipe.setID(document.id.toString());
      }
    });
    return recipes;
  }

  static void addRecipe(Recipe recipe, String userID) async {
    firestore
        .collection(userID + 'Recipes')
        .add(recipe.toJson())
        .then((value) => recipe.setID(value.id));
  }

  static void deleteRecipe(Recipe recipe, String userID) {
    firestore.collection(userID + 'Recipes').doc(recipe.id).delete();
  }

  static Future<List<FoodItem>> getExpiringFoodItems(String userID) async {
    List<FoodItem> foodItems = [];
    await firestore
        .collection(userID + 'FoodItem')
        .where('expires',
            isLessThanOrEqualTo: DateTime.now().add(const Duration(days: 5)))
        .limit(5)
        .get()
        .then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        FoodItem foodItem = FoodItem.fromJson(document.data());
        foodItems.add(foodItem);
        foodItem.setID(document.id.toString());
      }
    });
    return foodItems;
  }

  static Future<List<Recipe>> getRecommendedRecipes(
      List<FoodItem> expiringFoodItems, String userID) async {
    List<Recipe> recipes = [];
    await firestore.collection(userID + 'Recipes').get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        Recipe recipe = Recipe.fromJson(document.data());
        for (Map ingredients in recipe.ingredients) {
          for (FoodItem foodItem in expiringFoodItems) {
            if ((ingredients['name'] as String).toLowerCase().trim() ==
                foodItem.name.toLowerCase().trim()) {
              if (recipes.length < 5 && !recipes.contains(recipe)) {
                recipes.add(recipe);
                recipe.setID(document.id.toString());
              }
            }
          }
        }
      }
    });
    return recipes;
  }

  static void updateFoodItemsFromRecipe(Recipe recipe, String userID) async {
    Future<List<FoodItem>> foodItemsFuture = getFoodItems(userID);
    List<FoodItem> foodItems = await foodItemsFuture;
    for (FoodItem foodItem in foodItems) {
      for (Map recipeIngredient in recipe.ingredients) {
        if (foodItem.name == recipeIngredient['name']) {
          int quantity = foodItem.quantity;
          foodItem
              .setQuantity(quantity -= int.parse(recipeIngredient['amount']));
          if (foodItem.quantity <= 0) {
            deleteFoodItem(foodItem, userID);
          } else {
            updateFoodItem(foodItem, 'quantity', foodItem.quantity, userID);
          }
        }
      }
    }
  }

  static Future<double> getUserPercentWasted(String userID) async {
    double percentWasted = 0;
    await firestore.collection(userID + 'User').get().then((querySnapshot) {
      CubbyUser user = CubbyUser.fromJson(querySnapshot.docs.first.data());
      percentWasted = user.percentWasted;
    });
    return percentWasted;
  }

  static void addUser(String userID, String name) async {
    CubbyUser user = CubbyUser(userID, name, 1, 0, true);
    firestore.collection(userID + 'User').add(user.toJson());
  }

  static Future<CubbyUser> getUser(String userID) async {
    CubbyUser user = CubbyUser('', '', 1, 0, true);
    await firestore.collection(userID + 'User').get().then((querySnapshot) {
      user = CubbyUser.fromJson(querySnapshot.docs.first.data());
    });
    return user;
  }

  static void updateUserFoodWasted(String userID) {
    CubbyUser cubbyUser = getUser(userID) as CubbyUser;
    firestore
        .collection(userID + 'User')
        .doc()
        .update({'foodWasted': cubbyUser.foodWasted + 1});
  }

  static void updateUserFoodUsed(String userID, int amount) {
    CubbyUser cubbyUser = getUser(userID) as CubbyUser;
    firestore
        .collection(userID + 'User')
        .doc()
        .update({'foodUsed': cubbyUser.foodUsed + amount});
  }
}
