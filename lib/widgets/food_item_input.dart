import 'package:cubby/constants/constants.dart' as constants;
import 'package:cubby/views/home/home.dart';
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';

class FoodItemInput extends StatefulWidget {
  late String userID;

  FoodItemInput({required this.userID, Key? key}) : super(key: key);
  @override
  _FoodItemInputState createState() => _FoodItemInputState();
}

class _FoodItemInputState extends State<FoodItemInput> {
  late String selectedFoodType = 'Fruit';
  late bool foodOpened = false;
  late DateTime foodExpiry = DateTime.now();
  final name = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  Future<void> foodExpiryInput(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: foodExpiry,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != foodExpiry) {
      setState(() {
        foodExpiry = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: const Text(
        'Enter Food Item:',
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      content: SingleChildScrollView(
        child: Column(
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
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text('Type: '),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                        alignment: Alignment.centerLeft,
                        dropdownColor: Colors.amber[300],
                        items: constants.foodTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: selectedFoodType,
                        onChanged: (String? newValue) {
                          setState(() {});
                          selectedFoodType = newValue!;
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                  title: const Text('Food Opened?'),
                  activeColor: Colors.lightGreen,
                  value: foodOpened,
                  onChanged: (bool? value) {
                    setState(() {
                      foodOpened = value!;
                    });
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Expires: ' + "${foodExpiry.toLocal()}".split(' ')[0]),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () => foodExpiryInput(context),
                    child: const Text('Select date'),
                  ),
                ],
              ),
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            int foodType = constants.foodTypes.indexOf(selectedFoodType);
            FoodItem foodItem = FoodItem(
              name.text,
              foodType,
              foodOpened,
              foodExpiry,
            );
            FirebaseCRUD.addFoodItem(foodItem, widget.userID);
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(0),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
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
