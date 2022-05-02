import 'package:cubby/constants/constants.dart' as constants;
import 'package:flutter/material.dart';

import '../../../models/food_item.dart';
import 'food_item_delete_check.dart';
import 'food_item_edit.dart';

// ignore: must_be_immutable
class FoodItemCard extends StatefulWidget {
  late FoodItem foodItem;
  late String userID;
  FoodItemCard({required this.foodItem, required this.userID, Key? key})
      : super(key: key);
  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard> {
  @override
  Widget build(BuildContext context) {
    ImageIcon openedIcon;
    if (widget.foodItem.opened) {
      openedIcon = const ImageIcon(
        AssetImage('assets/images/openedtin.png'),
        color: Colors.white,
        size: 30,
      );
    } else {
      openedIcon = const ImageIcon(
        AssetImage('assets/images/closedtin.png'),
        color: Colors.white,
        size: 30,
      );
    }
    String expiry;
    Color? expiryColor;
    if ((widget.foodItem.expires.toLocal().difference(DateTime.now()).inHours /
                24)
            .ceil() <
        0) {
      expiry = 'Expired';
      expiryColor = Colors.red;
    } else if ((widget.foodItem.expires
                    .toLocal()
                    .difference(DateTime.now())
                    .inHours /
                24)
            .ceil() ==
        0) {
      expiry = 'Expires Today';
      expiryColor = Colors.red[400];
    } else {
      List<String> expiresToSplit =
          widget.foodItem.expires.toLocal().toString().split(' ')[0].split('-');
      expiry = '${expiresToSplit[2]}/${expiresToSplit[1]}';
      expiryColor = Colors.white;
    }

    return Card(
        color: Colors.lightGreen,
        elevation: 8,
        margin: const EdgeInsets.all(8),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.lightGreen, width: 1)),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 116,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      const Spacer(),
                      openedIcon,
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(
                    text: expiry,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: expiryColor,
                      fontSize: 15,
                    ),
                  )),
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                        text:
                            "Quantity: ${widget.foodItem.quantity} ${constants.foodMeasurements[widget.foodItem.measurement]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      )),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => FoodItemEdit(
                              foodItem: widget.foodItem,
                              userID: widget.userID,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                        iconSize: 18,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  FoodItemDeleteCheck(
                                    foodItem: widget.foodItem,
                                    userID: widget.userID,
                                  ));
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.white,
                        iconSize: 18,
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
