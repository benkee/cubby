import 'package:cubby/views/home/home.dart';
import 'package:flutter/material.dart';

class RecipeIngredientsInput extends StatefulWidget {
  const RecipeIngredientsInput({Key? key}) : super(key: key);

  @override
  _RecipeIngredientsInputState createState() => _RecipeIngredientsInputState();
}

class _RecipeIngredientsInputState extends State<RecipeIngredientsInput> {
  List<String> _ingredients = [];
  int _ingredientsCount = 0;

  @override
  void dispose() {
    super.dispose();
  }

  _row(int index) {
    return Row(
      children: [
        Text('ID: $index'),
        const SizedBox(width: 30),
        Expanded(
          child: TextFormField(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _ingredientsCount,
        itemBuilder: (context, index) {
          return _row(index);
        },
      ),
    );
  }
}
