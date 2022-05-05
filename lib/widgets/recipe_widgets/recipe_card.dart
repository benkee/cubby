import 'package:cubby/widgets/recipe_widgets/recipe_cook_display.dart';
import 'package:cubby/widgets/recipe_widgets/recipe_delete_check.dart';
import 'package:cubby/widgets/recipe_widgets/recipe_edit.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../../models/recipe.dart';

// ignore: must_be_immutable
class RecipeCard extends StatefulWidget {
  late Recipe recipe;
  late String userID;
  RecipeCard({required this.recipe, required this.userID, Key? key})
      : super(key: key);
  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String bullet = "\u2022 ";
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.lightGreen,
        elevation: 8,
        margin: const EdgeInsets.all(15),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightGreen, width: 1)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 200,
          width: double.maxFinite,
          child: Column(children: [
            Row(
              children: [
                RichText(
                    text: TextSpan(
                  text: widget.recipe.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                )),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => RecipeEdit(
                        recipe: widget.recipe,
                        userID: widget.userID,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => RecipeDeleteCheck(
                              recipe: widget.recipe,
                              userID: widget.userID,
                            ));
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                ),
              ],
            ),
            Row(children: [
              Column(
                children: [
                  RichText(
                      text: const TextSpan(
                    text: 'Instructions: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )),
                  SizedBox(
                    width: 140,
                    height: 55,
                    child: RawScrollbar(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.recipe.instructions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              '\u2022 ' +
                                  widget.recipe.instructions[index]['step'],
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            );
                          }),
                      thumbColor: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  RichText(
                      text: const TextSpan(
                    text: 'Ingredients: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )),
                  SizedBox(
                    width: 140,
                    height: 55,
                    child: RawScrollbar(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.recipe.ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              '\u2022  ${widget.recipe.ingredients[index]['amount']} ${widget.recipe.ingredients[index]['measurement']} of ${widget.recipe.ingredients[index]['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            );
                          }),
                      thumbColor: Colors.amber,
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => RecipeCookDisplay(
                            recipe: widget.recipe,
                            userID: widget.userID,
                          ));
                },
                child: const Text(
                  'COOK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              const Spacer(),
              RichText(
                  text: TextSpan(
                text: '£${widget.recipe.cost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
              const SizedBox(
                width: 20,
              ),
              RichText(
                  text: TextSpan(
                text: widget.recipe.preparationTime.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  text: ' mins',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  await Share.share(convertRecipeToShareableString());
                },
                icon: const Icon(Icons.share),
                color: Colors.white,
              ),
            ]),
          ]),
        ));
  }

  String convertRecipeToShareableString() {
    String shareableString;
    String ingredientsString = '';
    String instructionsString = '';
    for (Map ingredient in widget.recipe.ingredients) {
      ingredientsString +=
          '\n\u2022 ${ingredient['amount']} ${ingredient['measurement']} of ${ingredient['name']}';
    }
    for (Map instructions in widget.recipe.instructions) {
      instructionsString +=
          '\n\u2022 Step ${instructions['id'] + 1}: ${instructions['step']}';
    }
    shareableString = 'My Cubby Recipe:\nName: ' +
        widget.recipe.name +
        '\nPreparation Time: ' +
        widget.recipe.preparationTime.toString() +
        '\nCost: ' +
        widget.recipe.cost.toString() +
        '\nIngredients: ' +
        ingredientsString +
        '\nInstructions: ' +
        instructionsString;
    return shareableString;
  }
}
