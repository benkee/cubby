import 'package:cubby/constants/constants.dart' as constants;
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import 'food_item_card.dart';

class FoodItemExpansionTile extends StatefulWidget {
  final int type;
  final List<FoodItem> foodItems;
  final String userID;
  const FoodItemExpansionTile(
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
    return ExpansionTile(
        iconColor: Colors.white,
        backgroundColor: Colors.amber[250],
        collapsedBackgroundColor: Colors.amber[350],
        title: Row(children: [
          Text(
            constants.foodTypes[widget.type],
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 35,
            ),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundImage: AssetImage(constants.foodTypeImage[widget.type]),
            radius: 30,
          ),
        ]),
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
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
