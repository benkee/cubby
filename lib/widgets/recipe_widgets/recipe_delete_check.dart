import 'package:flutter/material.dart';

import '../../../services/firebase_crud.dart';
import '../../models/recipe.dart';
import '../../views/home/home.dart';

// ignore: must_be_immutable
class RecipeDeleteCheck extends StatefulWidget {
  late Recipe recipe;
  late String userID;
  RecipeDeleteCheck({required this.recipe, required this.userID, Key? key})
      : super(key: key);
  @override
  _RecipeDeleteCheckState createState() => _RecipeDeleteCheckState();
}

class _RecipeDeleteCheckState extends State<RecipeDeleteCheck> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: Text(
        'Delete ${widget.recipe.name}',
        style: const TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            FirebaseCRUD.deleteRecipe(widget.recipe, widget.userID);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage(2)));
          },
          child:
              const Text('Delete Item', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
