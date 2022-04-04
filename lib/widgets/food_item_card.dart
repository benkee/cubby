import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import 'package:cubby/constants/constants.dart' as constants;
import 'food_item_delete_check.dart';
import 'food_item_edit.dart';

// ignore: must_be_immutable
class FoodItemCard extends StatefulWidget {
  late FoodItem foodItem;
  FoodItemCard({required this.foodItem, Key? key}) : super(key: key);
  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[500],
        elevation: 8,
        margin: const EdgeInsets.all(15),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightGreen, width: 1)),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 100,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                        text: widget.foodItem.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: constants.foodTypes[widget.foodItem.type],
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                              ))
                        ],
                      )),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  FoodItemEdit(foodItem: widget.foodItem),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    FoodItemDeleteCheck(
                                      foodItem: widget.foodItem,
                                    ));
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                  Text('Opened: ${widget.foodItem.opened}'),
                  const Spacer(),
                  Text('Expires: ' +
                      "${widget.foodItem.expires.toLocal()}".split(' ')[0]),
                ],
              ),
            )));
  }
}
