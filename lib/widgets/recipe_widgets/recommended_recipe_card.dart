import 'package:cubby/widgets/recipe_widgets/recipe_cook_display.dart';
import 'package:flutter/material.dart';

import '../../../models/recipe.dart';

// ignore: must_be_immutable
class RecommendedRecipeCard extends StatefulWidget {
  late Recipe recipe;
  late String userID;
  RecommendedRecipeCard({required this.recipe, required this.userID, Key? key})
      : super(key: key);
  @override
  State<RecommendedRecipeCard> createState() => _RecommendedRecipeCardState();
}

class _RecommendedRecipeCardState extends State<RecommendedRecipeCard> {
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
          height: 205,
          width: double.maxFinite,
          child: Column(children: [
            RichText(
                text: TextSpan(
              text: widget.recipe.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            )),
            Row(children: [
              RichText(
                  text: TextSpan(
                text: 'Prep Time: ${widget.recipe.preparationTime.toString()}',
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
                  )),
              const SizedBox(
                width: 70,
              ),
              RichText(
                  text: TextSpan(
                text: 'Cost: £${widget.recipe.cost.toString()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
            ]),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              Column(
                children: [
                  RichText(
                      text: const TextSpan(
                    text: 'Ingredients: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: RawScrollbar(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.recipe.ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              '\u2022  ${widget.recipe.ingredients[index]['amount']} ${widget.recipe.ingredients[index]['measurement']} of ${widget.recipe.ingredients[index]['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
              height: 5,
            ),
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
          ]),
        ));
  }
}
