import 'package:flutter/material.dart';
import '../models/food_item.dart';

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
        color: Colors.blueGrey,
        elevation: 8,
        margin: const EdgeInsets.all(15),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightGreen, width: 1)),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 200,
            width: double.maxFinite,
            child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      text: widget.foodItem.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                widget.foodItem.foodTypes[widget.foodItem.type],
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ))
                      ]),
                ))));
  }
}