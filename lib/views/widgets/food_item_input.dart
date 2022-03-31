import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cubby/constants/constants.dart' as constants;

import '../../models/food_item.dart';
import '../../services/crud.dart';

class FoodItemInput extends StatefulWidget {
  @override
  _FoodItemInputState createState() => _FoodItemInputState();
}

class _FoodItemInputState extends State<FoodItemInput> {
  late String selectedValue;
  final name = TextEditingController();

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
        'Enter Food Item',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: name,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            DropdownButton<String>(
                items: constants.foodTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {});
                  selectedValue = newValue!;
                }),
          ]),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            int foodType = constants.foodTypes.indexOf(selectedValue);
            FoodItem foodItem = FoodItem(name.text, foodType);
            FirebaseCRUD.addFoodItem(foodItem,
                FirebaseAuth.instance.currentUser?.uid.toString() ?? '');
            Navigator.of(context).pop();
          },
          child: const Text('Add Item', style: TextStyle(color: Colors.white)),
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
}
