import 'package:cubby/models/recipe.dart';
import 'package:cubby/services/firebase_crud.dart';
import 'package:flutter/material.dart';

import '../views/home/home.dart';

// ignore: must_be_immutable
class RecipeCookDisplay extends StatefulWidget {
  late Recipe recipe;
  late String userID;
  RecipeCookDisplay({required this.recipe, required this.userID, Key? key})
      : super(key: key);
  @override
  _RecipeCookDisplayState createState() => _RecipeCookDisplayState();
}

class _RecipeCookDisplayState extends State<RecipeCookDisplay> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: Text(
        widget.recipe.name,
        style: const TextStyle(color: Colors.white, fontSize: 40),
        overflow: TextOverflow.ellipsis,
      ),
      actionsAlignment: MainAxisAlignment.start,
      alignment: Alignment.center,
      actions: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: const TextSpan(
              text: 'Ingredients: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            )),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 280,
              height: 100,
              child: RawScrollbar(
                child: ListView.builder(
                    itemCount: widget.recipe.ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        '\u2022  ${widget.recipe.ingredients[index]['amount']} ${widget.recipe.ingredients[index]['measurement']} of ${widget.recipe.ingredients[index]['name']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }),
                thumbColor: Colors.amber,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
                text: const TextSpan(
              text: 'Instructions: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            )),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 280,
              height: 140,
              child: RawScrollbar(
                child: ListView.builder(
                    itemCount: widget.recipe.instructions.length,
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        '\u2022 ' + widget.recipe.instructions[index]['step'],
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }),
                thumbColor: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                FirebaseCRUD.updateFoodItemsFromRecipe(
                    widget.recipe, widget.userID);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage(1)));
              },
              child: const Text('Finished Cooking',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }
}
