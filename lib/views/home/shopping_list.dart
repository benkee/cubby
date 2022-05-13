import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/recipe.dart';
import '../../services/firebase_crud.dart';
import '../../widgets/shopping_list_generate.dart';

class ShoppingListPage extends StatefulWidget {
  final String userID;

  const ShoppingListPage({required this.userID, Key? key}) : super(key: key);
  getState() => _ShoppingListPageState();
  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late int _recipesCount;
  late Map _recipes;
  late Map selectedItemName = {0: 'Select a Recipe'};
  late bool includeInventoryItems;
  late String _shoppingList = 'Failed to gather shopping list.';

  @override
  void initState() {
    super.initState();
    _recipesCount = 1;
    _recipes = {};
    includeInventoryItems = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[300],
      body: Column(children: [
        const Text(
          'To generate a shopping list, add the recipes you wish to cook',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Add Recipes: ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const Spacer(),
            IconButton(
                onPressed: () async {
                  setState(
                    () {
                      _recipesCount++;
                      selectedItemName[_recipesCount - 1] = 'Select a Recipe';
                    },
                  );
                },
                icon: const Icon(Icons.add)),
            IconButton(
              onPressed: () async {
                setState(
                  () {
                    if (_recipesCount > 1) {
                      selectedItemName.remove(_recipesCount - 1);
                      _recipes.remove(_recipesCount - 1);
                      _recipesCount--;
                    }
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        SizedBox(
          height: 300,
          width: 600,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemBuilder: (context, key) {
                    Widget returnWidget;
                    if (_recipesRow(key) == null) {
                      returnWidget = const CircularProgressIndicator();
                    } else {
                      returnWidget = _recipesRow(key);
                    }
                    return returnWidget;
                  },
                  shrinkWrap: true,
                  itemCount: _recipesCount,
                ),
              )
            ],
          ),
        ),
        CheckboxListTile(
            title: const Text(
              'Remove current inventory \nitems from shopping list: ',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            activeColor: Colors.lightGreen,
            value: includeInventoryItems,
            onChanged: (bool? value) {
              setState(() {
                includeInventoryItems = value!;
              });
            }),
        const SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.amber[300],
                title: const Text(
                  'Shopping List',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                  overflow: TextOverflow.ellipsis,
                ),
                actionsAlignment: MainAxisAlignment.start,
                alignment: Alignment.center,
                actions: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                          future: ShoppingListGenerate.generate(
                              _recipes, includeInventoryItems, widget.userID),
                          builder: (context, projectSnap) {
                            if (projectSnap.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (projectSnap.hasError) {
                              return Center(
                                child: Text(
                                    'Error gathering data: ${projectSnap.error}'),
                              );
                            } else {
                              _shoppingList = projectSnap.data.toString();
                              return SizedBox(
                                height: 500,
                                child: SingleChildScrollView(
                                  child: Text(
                                    _shoppingList,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      IconButton(
                        onPressed: () async {
                          await Share.share(_shoppingList);
                        },
                        icon: const Icon(Icons.share),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          child: const Text(
            'Generate Shopping List',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        )
      ]),
    );
  }

  _recipesRow(int key) {
    return DropdownButtonHideUnderline(
      child: FutureBuilder<List<Recipe>>(
        future: FirebaseCRUD.getRecipes(widget.userID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            return DropdownButton(
              dropdownColor: Colors.amber[300],
              items: snapshot.data
                  ?.map(
                    (recipe) => DropdownMenuItem(
                      alignment: Alignment.center,
                      child: Text(recipe.name),
                      value: recipe,
                    ),
                  )
                  .toList(),
              onChanged: (recipe) {
                Recipe? _selectedItem = recipe as Recipe?;
                setState(
                  () {
                    if (_selectedItem?.name != null) {
                      _recipes[key] = _selectedItem;
                      selectedItemName[key] = _selectedItem?.name;
                    }
                  },
                );
              },
              hint: SizedBox(
                width: 350,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ' - ' + selectedItemName[key]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
