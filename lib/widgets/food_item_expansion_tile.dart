import 'package:cubby/constants/constants.dart' as constants;
import 'package:flutter/material.dart';

import '../models/food_item.dart';
import 'food_item_card.dart';

class FoodItemExpansionTile extends StatefulWidget {
  late int type;
  late List<FoodItem> foodItems;
  late String userID;
  FoodItemExpansionTile(
      {required this.type,
      required this.foodItems,
      required this.userID,
      Key? key})
      : super(key: key);

  @override
  State<FoodItemExpansionTile> createState() => _FoodItemExpansionTileState();
}

class _FoodItemExpansionTileState extends State<FoodItemExpansionTile> {
  @override
  Widget build(BuildContext context) {
    print(widget.type);
    print(widget.foodItems.toString());
    return ExpansionTile(
        title: Text(constants.foodTypes[widget.type]),
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.foodItems.length,
              itemBuilder: (context, index) {
                try {
                  return FoodItemCard(
                    foodItem: widget.foodItems[index],
                    userID: widget.userID,
                  );
                } catch (e) {
                  return const Text('Failed to load items');
                }
              }),
        ]);
  }
}
