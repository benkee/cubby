import 'package:cubby/constants/constants.dart' as constants;
import 'package:cubby/widgets/food_item_widgets/food_item_expansion_tile.dart';
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';
import '../../widgets/food_item_widgets/food_item_input.dart';

class InventoryPage extends StatefulWidget {
  final String userID;

  const InventoryPage({required this.userID, Key? key}) : super(key: key);
  getState() => _InventoryPageState();
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.amber[300],
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (projectSnap.hasError) {
            return Center(
              child: Text('Error gathering data: ${projectSnap.error}'),
            );
          } else {
            List<FoodItem> foodItems = projectSnap.data as List<FoodItem>;
            Map categorizedFoodItems = {};
            List<Widget> expansionTiles = [];
            for (int i = 0; i < constants.foodTypes.length; i++) {
              categorizedFoodItems[i] =
                  foodItems.where((element) => element.type == i).toList();
              categorizedFoodItems[i].sort((a, b) =>
                  (a.expires.toString()).compareTo(b.expires.toString()));
              expansionTiles.add(FoodItemExpansionTile(
                  type: i,
                  foodItems: categorizedFoodItems[i],
                  userID: widget.userID));
            }
            return ListView(
              children: expansionTiles,
            );
          }
        },
        future: FirebaseCRUD.getFoodItems(widget.userID),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          foregroundColor: Colors.lightGreen,
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => FoodItemInput(
                userID: widget.userID,
              ),
            );
          },
        ),
      ),
    );
  }
}
