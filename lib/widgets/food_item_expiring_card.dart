import 'package:cubby/constants/constants.dart' as constants;
import 'package:cubby/services/firebase_crud.dart';
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../views/home/home.dart';

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
        widget.foodItem.expires.toLocal().difference(DateTime.now()).inDays;
    Color? cardColor = Colors.lightGreen;
    String expiresText = 'Expires in $daysRemaining days';
    switch (daysRemaining) {
      case 1:
        cardColor = Colors.red[400];
        expiresText = 'Expires tomorrow';
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
                      IconButton(
                        onPressed: () {
                          FirebaseCRUD.deleteFoodItem(
                              widget.foodItem, widget.userID);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(1)));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        iconSize: 25,
                      ),
                    ],
                  ),
                ))));
  }
}
