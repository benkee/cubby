import 'package:cubby/constants/constants.dart' as constants;

import '../models/food_item.dart';
import '../models/recipe.dart';
import '../services/firebase_crud.dart';

// ignore: must_be_immutable
class ShoppingListGenerate {
  static revertRecipes(List ingredientsNoDuplicates) {
    for (Map ingredient in ingredientsNoDuplicates) {
      ingredient['amount'] = (int.parse(ingredient['amount']) -
              int.parse(ingredient['revertAmount']))
          .toString();
    }
  }

  static List getAllIngredientsNoDuplicates(List allIngredientsFromRecipes) {
    List ingredientsNoDuplicates = [];
    for (Map ingredient in allIngredientsFromRecipes) {
      var found = ingredientsNoDuplicates.firstWhere(
          (ingredientNoDuplicate) =>
              ingredient['name'] == ingredientNoDuplicate['name'] &&
              ingredient['measurement'] == ingredientNoDuplicate['measurement'],
          orElse: () => null);
      if (found == null) {
        ingredient['revertAmount'] = '0';
        ingredientsNoDuplicates.add(ingredient);
      } else {
        found['amount'] =
            (int.parse(found['amount']) + int.parse(ingredient['amount']))
                .toString();
        found['revertAmount'] =
            (int.parse(found['revertAmount']) + int.parse(ingredient['amount']))
                .toString();
      }
    }
    return ingredientsNoDuplicates;
  }

  static List getAllIngredientsFromRecipes(Map recipes) {
    List allIngredientsFromRecipes = [];
    recipes.forEach(
      (key, value) {
        List<dynamic> recipeIngredients = (value as Recipe).ingredients;
        for (Map ingredientFromRecipes in recipeIngredients) {
          allIngredientsFromRecipes.add(ingredientFromRecipes);
        }
      },
    );
    return allIngredientsFromRecipes;
  }

  static List getIngredientsMinusInventory(
      List ingredientsNoDuplicates, List<FoodItem> foodItems) {
    List ingredientsMinusInventory = [];
    for (var ingredient in ingredientsNoDuplicates) {
      for (FoodItem foodItem in foodItems) {
        if ((ingredient['name'] as String).toLowerCase().trim() ==
                foodItem.name.toLowerCase().trim() &&
            ingredient['measurement'] ==
                constants.foodMeasurements[foodItem.measurement]) {
          ingredient['amount'] =
              (int.parse(ingredient['amount']) - foodItem.quantity).toString();
        }
        if (int.parse(ingredient['amount']) > 0 &&
            !ingredientsMinusInventory.contains(ingredient)) {
          ingredientsMinusInventory.add(ingredient);
        }
      }
    }
    return ingredientsMinusInventory;
  }

  static Future<String> generate(
      final Map recipes, bool includeInventoryItems, String userID) async {
    String _shoppingList = '';
    Map newRecipes = Map.from(recipes);
    List allIngredientsFromRecipes =
        getAllIngredientsFromRecipes(newRecipes.isEmpty ? {} : recipes);
    List ingredientsNoDuplicates =
        getAllIngredientsNoDuplicates(allIngredientsFromRecipes);

    await FirebaseCRUD.getFoodItems(userID).then((List<FoodItem> foodItems) {
      if (includeInventoryItems) {
        print(ingredientsNoDuplicates);
        var ingredientsMinusInventory =
            getIngredientsMinusInventory(ingredientsNoDuplicates, foodItems);
        print(ingredientsMinusInventory);
        for (var ingredient in ingredientsMinusInventory) {
          _shoppingList +=
              '\u2022  ${ingredient['amount']} ${ingredient['measurement']} of ${ingredient['name']}\n';
        }
      } else {
        for (var ingredient in ingredientsNoDuplicates) {
          _shoppingList +=
              '\u2022  ${ingredient['amount']} ${ingredient['measurement']} of ${ingredient['name']}\n';
        }
      }
    });
    if (_shoppingList == '') {
      _shoppingList = 'Failed to gather recipes.';
    }
    revertRecipes(ingredientsNoDuplicates);
    return _shoppingList;
  }
}
