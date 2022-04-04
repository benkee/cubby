import 'package:cubby/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:cubby/constants/constants.dart' as constants;

import '../../models/recipe.dart';
import '../../services/firebase_crud.dart';

class RecipeInput extends StatefulWidget {
  const RecipeInput({Key? key}) : super(key: key);

  @override
  _RecipeInputState createState() => _RecipeInputState();
}

class _RecipeInputState extends State<RecipeInput> {
  final name = TextEditingController();
  final ingredients = TextEditingController();
  final preparationTime = TextEditingController();
  final instructions = TextEditingController();
  final cost = TextEditingController();
  late int _ingredientsCount;
  late int _instructionsCount;
  late List<Map<String, dynamic>> _ingredientValues;
  late List<Map<String, dynamic>> _instructionsValues;
  late String result;

  @override
  void initState() {
    super.initState();
    _ingredientsCount = 1;
    _ingredientValues = [];
    _instructionsCount = 1;
    _instructionsValues = [];
    result = '';
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: const Text(
        'Enter Recipe: ',
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: name,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: cost,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'cost',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: preparationTime,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'preparationTime',
                ),
              ),
              const SizedBox(height: 20),
              //const RecipeIngredientsInput(),
              Row(
                children: [
                  const Text('Add Ingredients: '),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          _ingredientsCount++;
                        });
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          if (_ingredientsCount > 1) {
                            _ingredientsCount--;
                          }
                        });
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
              SizedBox(
                height: 120,
                width: 300,
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemBuilder: (context, key) {
                          return _ingredientsRow(key);
                        },
                        shrinkWrap: true,
                        itemCount: _ingredientsCount,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //const RecipeIngredientsInput(),
              Row(
                children: [
                  const Text('Add Instructions: '),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          _instructionsCount++;
                        });
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          if (_instructionsCount > 1) {
                            _instructionsCount--;
                          }
                        });
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
              SizedBox(
                height: 120,
                width: 300,
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemBuilder: (context, key) {
                          return _instructionsRow(key);
                        },
                        shrinkWrap: true,
                        itemCount: _instructionsCount,
                      ),
                    )
                  ],
                ),
              ),
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Recipe recipe = Recipe(
              name.text,
              _ingredientValues,
              int.parse(preparationTime.text),
              _instructionsValues,
              int.parse(cost.text),
            );
            FirebaseCRUD.addRecipe(recipe);
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(2),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child:
              const Text('Add Recipe', style: TextStyle(color: Colors.white)),
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

  _ingredientsRow(int key) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                onChanged: (value) {
                  _onIngredientsNameUpdate(key, value);
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Name"))),
        Expanded(
            child: TextFormField(
                onChanged: (value) {
                  _onIngredientsAmountUpdate(key, value);
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Amount"))),
        Expanded(
          child: DropdownButton<String>(
              alignment: Alignment.centerLeft,
              dropdownColor: Colors.amber[300],
              items: constants.foodMeasurements.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: getIngredientMeasurement(key),
              onChanged: (String? newValue) {
                setState(() {});
                _ingredientValues.elementAt(key)['measurement'] = newValue!;
              }),
        ),
      ],
    );
  }

  _onIngredientsNameUpdate(int key, String value) {
    Map<String, dynamic> json = {'id': key, 'name': value};
    bool replaced = false;
    for (var map in _ingredientValues) {
      if (map['id'] == key) {
        map['name'] = value;
      }
      replaced = true;
    }
    if (!replaced) _ingredientValues.add(json);
  }

  _onIngredientsAmountUpdate(int key, String value) {
    Map<String, dynamic> json = {'id': key, 'amount': value};
    bool replaced = false;
    for (var map in _ingredientValues) {
      if (map['id'] == key) {
        map['amount'] = value;
      }
      replaced = true;
    }
    if (!replaced) _ingredientValues.add(json);
  }

  String getIngredientMeasurement(int index) {
    try {
      return _ingredientValues.elementAt(index)['measurement'];
    } catch (e) {
      _ingredientValues.add({'id': index, 'measurement': 'g'});
      return _ingredientValues.elementAt(index)['measurement'];
    }
  }

  _instructionsRow(int key) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                onChanged: (value) {
                  _onInstructionsUpdate(key, value);
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: 'Add Step'))),
      ],
    );
  }

  void _onInstructionsUpdate(int key, String value) {
    Map<String, dynamic> json = {'id': key, 'step': value};
    bool replaced = false;
    for (var map in _instructionsValues) {
      if (map['id'] == key) {
        map['step'] = value;
      }
      replaced = true;
    }
    if (!replaced) _instructionsValues.add(json);
  }
}
