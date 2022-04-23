import 'package:cubby/widgets/recipe_delete_check.dart';
import 'package:cubby/widgets/recipe_edit.dart';
import 'package:flutter/material.dart';

import '../../models/recipe.dart';

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
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(widget.recipe.name),
                      const Spacer(flex: 10),
                      Text('cost: ' + widget.recipe.cost.toString()),
                      const Spacer(),
                      Text('Prep Time: ' +
                          widget.recipe.preparationTime.toString()),
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
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    RecipeDeleteCheck(
                                      recipe: widget.recipe,
                                      userID: widget.userID,
                                    ));
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Ingredients:'),
                  Expanded(
                    child: RawScrollbar(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.recipe.ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                                '\u2022  ${widget.recipe.ingredients[index]['amount']}${widget.recipe.ingredients[index]['measurement']} of ${widget.recipe.ingredients[index]['name']}');
                          }),
                      thumbColor: Colors.amber,
                    ),
                  ),
                  const Text('Instructions: '),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: RawScrollbar(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: widget.recipe.instructions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text('\u2022 ' +
                                  widget.recipe.instructions[index]['step']);
                            }),
                        thumbColor: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}