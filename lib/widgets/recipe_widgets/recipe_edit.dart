import 'package:cubby/constants/constants.dart' as constants;
import 'package:cubby/views/home/home.dart';
import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../../services/firebase_crud.dart';

class RecipeEdit extends StatefulWidget {
  final String userID;
  final Recipe recipe;
  const RecipeEdit({required this.recipe, required this.userID, Key? key})
      : super(key: key);

  @override
  _RecipeEditState createState() => _RecipeEditState();
}

class _RecipeEditState extends State<RecipeEdit> {
  final name = TextEditingController();
  final ingredients = TextEditingController();
  final preparationTime = TextEditingController();
  final instructions = TextEditingController();
  final cost = TextEditingController();
  late int _ingredientsCount;
  late int _instructionsCount;
  late List<dynamic> _ingredientValues;
  late List<dynamic> _instructionsValues;
  late String result;

  @override
  void initState() {
    super.initState();
    _ingredientValues = widget.recipe.ingredients;
    _ingredientsCount = _ingredientValues.length;
    _instructionsValues = widget.recipe.instructions;
    _instructionsCount = _instructionsValues.length;
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
        'Edit Recipe: ',
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Name: '),
              TextField(
                controller: name,
                obscureText: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: widget.recipe.name,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Cost: '),
              TextField(
                controller: cost,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: widget.recipe.cost.toString(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Preparation Time: '),
              TextField(
                controller: preparationTime,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: widget.recipe.preparationTime.toString(),
                ),
              ),
              const SizedBox(height: 20),
              //const RecipeIngredientsInput(),
              Row(
                children: [
                  const Text('Edit Ingredients: '),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          _ingredientsCount++;
                          _ingredientValues.add({
                            'id': _ingredientsCount - 1,
                            'name': 'Name',
                            'amount': 'Amount',
                            'measurement': 'g',
                          });
                        });
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          if (_ingredientsCount > 1) {
                            _ingredientsCount--;
                            _ingredientValues.removeLast();
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
                      child: RawScrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, key) {
                            return _ingredientsRow(key);
                          },
                          shrinkWrap: true,
                          itemCount: _ingredientsCount,
                        ),
                        thumbColor: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //const RecipeIngredientsInput(),
              Row(
                children: [
                  const Text('Edit Instructions: '),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          _instructionsCount++;
                          _instructionsValues.add({
                            'id': _instructionsCount - 1,
                            'step': 'Step $_instructionsCount'
                          });
                        });
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          if (_instructionsCount > 1) {
                            _instructionsCount--;
                            _instructionsValues.removeLast();
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
                      child: RawScrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, key) {
                            return _instructionsRow(key);
                          },
                          shrinkWrap: true,
                          itemCount: _instructionsCount,
                        ),
                        thumbColor: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (name.text != '') {
              FirebaseCRUD.updateRecipe(
                  widget.recipe, 'name', name.text, widget.userID);
            }
            if (double.tryParse(cost.text) != null) {
              FirebaseCRUD.updateRecipe(widget.recipe, 'cost',
                  double.parse(cost.text), widget.userID);
            }
            if (int.tryParse(preparationTime.text) != null) {
              FirebaseCRUD.updateRecipe(widget.recipe, 'preparationTime',
                  preparationTime.text, widget.userID);
            }
            FirebaseCRUD.updateRecipe(
                widget.recipe, 'ingredients', _ingredientValues, widget.userID);
            FirebaseCRUD.updateRecipe(widget.recipe, 'instructions',
                _instructionsValues, widget.userID);

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomePage(2),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child:
              const Text('Edit Recipe', style: TextStyle(color: Colors.white)),
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
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: _ingredientValues[key]['name']))),
        Expanded(
            child: TextFormField(
                onChanged: (value) {
                  _onIngredientsAmountUpdate(key, value);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: _ingredientValues[key]['amount']))),
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
        replaced = true;
      }
    }
    if (!replaced) _ingredientValues.add(json);
  }

  _onIngredientsAmountUpdate(int key, String value) {
    Map<String, dynamic> json = {'id': key, 'amount': value};
    bool replaced = false;
    for (var map in _ingredientValues) {
      if (map['id'] == key) {
        map['amount'] = value;
        replaced = true;
      }
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
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: _instructionsValues[key]['step']))),
      ],
    );
  }

  void _onInstructionsUpdate(int key, String value) {
    Map<String, dynamic> json = {'id': key, 'step': value};
    bool replaced = false;
    for (var map in _instructionsValues) {
      if (map['id'] == key) {
        map['step'] = value;
        replaced = true;
      }
    }
    if (!replaced) _instructionsValues.add(json);
  }
}
