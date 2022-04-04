import 'package:flutter/material.dart';
import '../../models/recipe.dart';

// ignore: must_be_immutable
class RecipeCard extends StatefulWidget {
  late Recipe recipe;
  RecipeCard({required this.recipe, Key? key}) : super(key: key);
  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blueGrey,
        elevation: 8,
        margin: const EdgeInsets.all(15),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightGreen, width: 1)),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 100,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                        text: widget.recipe.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.recipe.cost.toString(),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                              ))
                        ],
                      )),
                      const Spacer(),
                      // IconButton(
                      //     onPressed: () {
                      //       showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) =>
                      //             FoodItemEdit(foodItem: widget.recipe),
                      //       );
                      //     },
                      //     icon: const Icon(Icons.edit)),
                      // IconButton(
                      //     onPressed: () {
                      //       showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) =>
                      //               FoodItemDeleteCheck(
                      //                 foodItem: widget.foodItem,
                      //               ));
                      //     },
                      //     icon: const Icon(Icons.delete)),
                    ],
                  ),
                  Text('Ingredients: ${widget.recipe.ingredients}'),
                  const Spacer(),
                  Text('Instructions: ${widget.recipe.instructions}'),
                ],
              ),
            )));
  }
}
