import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../services/firebase_crud.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/recipe_input.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);
  getState() => _RecipePageState();
  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (projectSnap.hasError) {
            return Center(
              child: Text('Error gathering data: ${projectSnap.error}'),
            );
          } else if (projectSnap.hasData &&
              (projectSnap.data as List<Recipe>).isEmpty) {
            return const Center(
              child: Text('Try adding a recipe with the + button'),
            );
          } else {
            return ListView.builder(
                itemCount: (projectSnap.data as List<Recipe>).length,
                itemBuilder: (context, index) {
                  List<Recipe> recipes = projectSnap.data as List<Recipe>;
                  return RecipeCard(recipe: recipes[index]);
                });
          }
        },
        future: FirebaseCRUD.getRecipes(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => RecipeInput(),
          );
        },
      ),
    );
  }
}
