import 'package:cubby/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/food_item.dart';
import 'food_item_freeze_check.dart';
import 'food_item_waste_check.dart';

// ignore: must_be_immutable
class ExpiringFoodItemCard extends StatefulWidget {
  late FoodItem foodItem;
  late String userID;
  ExpiringFoodItemCard({required this.foodItem, required this.userID, Key? key})
      : super(key: key);
  @override
  State<ExpiringFoodItemCard> createState() => _ExpiringFoodItemCardState();
}

class _ExpiringFoodItemCardState extends State<ExpiringFoodItemCard> {
  @override
  Widget build(BuildContext context) {
    int daysRemaining =
        (widget.foodItem.expires.toLocal().difference(DateTime.now()).inHours /
                24)
            .ceil();
    Color? cardColor = Colors.lightGreen;
    String expiresText = 'Expires in $daysRemaining days';
    //print(daysRemaining);
    switch (daysRemaining) {
      case 0:
        cardColor = Colors.red[600];
        expiresText = 'Expires today';
        break;
      case 1:
        cardColor = Colors.red[400];
        break;
      case 2:
        cardColor = Colors.orange[600];
        break;
      case 3:
        cardColor = Colors.orange[400];
        break;
      case 4:
        cardColor = Colors.yellow[600];
        break;
      case 5:
        cardColor = Colors.yellow[400];
        break;
      default:
        cardColor = Colors.red[500];
        expiresText = 'Expired';
        break;
    }
    if (daysRemaining > 5) {
      cardColor = Colors.lightGreen[400];
      expiresText = 'Expires in $daysRemaining days';
    }

    return SizedBox(
        width: 170,
        height: 170,
        child: Card(
            color: cardColor,
            elevation: 5,
            margin: const EdgeInsets.all(8),
            shape: const CircleBorder(),
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                height: 150,
                width: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                        text: widget.foodItem.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      )),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                          text: TextSpan(
                        text: expiresText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      )),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                          text: TextSpan(
                        text:
                            "${widget.foodItem.quantity} ${constants.foodMeasurements[widget.foodItem.measurement]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FoodItemFreezeCheck(
                                        foodItem: widget.foodItem,
                                        userID: widget.userID,
                                      ));
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.snowflake,
                              size: 25,
                              color: Colors.white,
                            ),
                            iconSize: 25,
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FoodItemWasteCheck(
                                        foodItem: widget.foodItem,
                                        userID: widget.userID,
                                      ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            iconSize: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}
