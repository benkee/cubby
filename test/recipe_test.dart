import 'package:cubby/models/recipe.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  String name = 'name';
  List<dynamic> ingredients = [];
  int preparationTime = 10;
  List<dynamic> instructions = [];
  int cost = 3;
  Recipe recipe =
      Recipe(name, ingredients, preparationTime, instructions, cost);

  test("A recipe is initialised correctly", () {
    expect(recipe.name, name);
    expect(recipe.ingredients, ingredients);
    expect(recipe.preparationTime, preparationTime);
    expect(recipe.instructions, instructions);
    expect(recipe.cost, cost);
  });

  test("Recipe items are changed correctly", () {
    String newName = 'newName';
    List<dynamic> newIngredients = [];
    int newPreparationTime = 20;
    List<dynamic> newInstructions = [];
    int newCost = 4;

    recipe.setName(newName);
    recipe.setIngredients(newIngredients);
    recipe.setPreparationTime(newPreparationTime);
    recipe.setInstructions(newInstructions);
    recipe.setCost(newCost);

    expect(recipe.name, newName);
    expect(recipe.ingredients, newIngredients);
    expect(recipe.preparationTime, newPreparationTime);
    expect(recipe.instructions, newInstructions);
    expect(recipe.cost, newCost);
  });
}
