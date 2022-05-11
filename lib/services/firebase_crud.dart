import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubby/constants/constants.dart' as constants;

import '../models/cubby_user.dart';
import '../models/food_item.dart';
import '../models/recipe.dart';

// ignore: camel_case_types
class FirebaseCRUD {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void addFoodItem(FoodItem foodItem, String userID) async {
    firestore
        .collection(userID)
        .doc('FoodItem')
        .collection('FoodItems')
        .add(foodItem.toJson());
  }

  static Future<List<FoodItem>> getFoodItems(String userID) async {
    List<FoodItem> foodItems = [];
    await firestore
        .collection(userID)
        .doc('FoodItem')
        .collection('FoodItems')
        .get()
        .then((snapshot) {
      for (var document in snapshot.docs) {
        FoodItem foodItem = FoodItem.fromJson(document.data());
        foodItem.setID(document.id.toString());
        foodItems.add(foodItem);
      }
    });
    return foodItems;
  }

  static void deleteFoodItem(FoodItem foodItem, String userID) {
    firestore
        .collection(userID)
        .doc('FoodItem')
        .collection('FoodItems')
        .doc(foodItem.id)
        .delete();
  }

  static void updateFoodItem(
      FoodItem foodItem, String field, dynamic value, String userID) {
    firestore
        .collection(userID)
        .doc('FoodItem')
        .collection('FoodItems')
        .doc(foodItem.id)
        .update({field: value});
  }

  static void updateRecipe(
      Recipe recipe, String field, dynamic value, String userID) {
    firestore
        .collection(userID)
        .doc('Recipe')
        .collection('Recipes')
        .doc(recipe.id)
        .update({field: value});
  }

  static Future<List<Recipe>> getRecipes(String userID) async {
    List<Recipe> recipes = [];
    await firestore
        .collection(userID)
        .doc('Recipe')
        .collection('Recipes')
        .get()
        .then((querySnapshot) {
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
        .collection(userID)
        .doc('Recipe')
        .collection('Recipes')
        .add(recipe.toJson())
        .then((value) => recipe.setID(value.id));
  }

  static void deleteRecipe(Recipe recipe, String userID) {
    firestore
        .collection(userID)
        .doc('Recipe')
        .collection('Recipes')
        .doc(recipe.id)
        .delete();
  }

  static Future<List<FoodItem>> getExpiringFoodItems(String userID) async {
    List<FoodItem> foodItems = [];
    await firestore
        .collection(userID)
        .doc('FoodItem')
        .collection('FoodItems')
        .orderBy('expires')
        .limit(5)
        .get()
        .then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        FoodItem foodItem = FoodItem.fromJson(document.data());
        foodItem.setID(document.id.toString());
        foodItems.add(foodItem);
      }
    });
    return foodItems;
  }

  static Future<List<Recipe>> getRecommendedRecipes(
      List<FoodItem> expiringFoodItems, String userID) async {
    List<Recipe> recipes = [];
    await firestore
        .collection(userID)
        .doc('Recipe')
        .collection('Recipes')
        .get()
        .then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        Recipe recipe = Recipe.fromJson(document.data());
        for (Map ingredients in recipe.ingredients) {
          for (FoodItem foodItem in expiringFoodItems) {
            if ((ingredients['name'] as String).toLowerCase().trim() ==
                    foodItem.name.toLowerCase().trim() &&
                constants.foodMeasurements[foodItem.measurement] ==
                    ingredients['measurement'] &&
                foodItem.quantity >= int.parse(ingredients['amount'])) {
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
    foodItems
        .sort((a, b) => (a.expires.toString()).compareTo(b.expires.toString()));
    for (Map recipeIngredient in recipe.ingredients) {
      bool recipeFoodItemRemoved = true;
      for (FoodItem foodItem in foodItems) {
        if ((foodItem.name).toLowerCase().trim() ==
                (recipeIngredient['name']).toLowerCase().trim() &&
            recipeFoodItemRemoved) {
          int quantity = foodItem.quantity;
          foodItem
              .setQuantity(quantity -= int.parse(recipeIngredient['amount']));
          if (foodItem.quantity <= 0) {
            recipeIngredient['amount'] = (0 - quantity).toString();
            deleteFoodItem(foodItem, userID);
          } else {
            updateFoodItem(foodItem, 'quantity', foodItem.quantity, userID);
            recipeFoodItemRemoved = false;
          }
        }
      }
    }
  }

  static void addUser(String userID, String name) async {
    CubbyUser user = CubbyUser(userID, name, 1, 0, true);
    firestore.collection(userID).doc('CubbyUser').set(user.toJson());
  }

  static Future<CubbyUser> getUser(String userID) async {
    CubbyUser user = CubbyUser('', '', 1, 0, true);
    await firestore
        .collection(userID)
        .doc('CubbyUser')
        .get()
        .then((querySnapshot) {
      user = CubbyUser.fromJson(querySnapshot.data() as Map<String, dynamic>);
    });
    return user;
  }

  static void updateUserFoodWasted(String userID) {
    getUser(userID).then((result) {
      CubbyUser cubbyUser = result;
      firestore
          .collection(userID)
          .doc('CubbyUser')
          .update({'foodWasted': cubbyUser.foodWasted + 1});
    });
  }

  static void updateUserFoodUsed(String userID, int amount) {
    getUser(userID).then((result) {
      CubbyUser cubbyUser = result;
      firestore
          .collection(userID)
          .doc('CubbyUser')
          .update({'foodUsed': (cubbyUser.foodUsed + amount)});
    });
  }
}
