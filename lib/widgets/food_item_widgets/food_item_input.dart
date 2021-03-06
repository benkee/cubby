import 'package:cubby/constants/constants.dart' as constants;
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';
import '../../views/home/home.dart';

class FoodItemInput extends StatefulWidget {
  final String userID;

  const FoodItemInput({required this.userID, Key? key}) : super(key: key);
  @override
  _FoodItemInputState createState() => _FoodItemInputState();
}

class _FoodItemInputState extends State<FoodItemInput> {
  late String selectedFoodType = 'Fruits';
  late bool foodOpened = false;
  late DateTime foodExpiry = DateTime.now();
  final name = TextEditingController();
  final quantity = TextEditingController();
  late int measurement = 0;
  String warning = '';

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    quantity.dispose();
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
              Text(warning, style: const TextStyle(color: Colors.red)),
              const SizedBox(
                height: 5,
              ),
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
              CheckboxListTile(
                  title: const Text('Food Opened: '),
                  activeColor: Colors.lightGreen,
                  value: foodOpened,
                  onChanged: (bool? value) {
                    setState(() {
                      foodOpened = value!;
                    });
                  }),
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
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: quantity,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Quantity',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                        alignment: Alignment.centerLeft,
                        dropdownColor: Colors.amber[300],
                        items: constants.foodMeasurements.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: constants.foodMeasurements[measurement],
                        onChanged: (String? newValue) {
                          setState(() {});
                          measurement =
                              constants.foodMeasurements.indexOf(newValue!);
                        }),
                  ),
                ],
              ),
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (name.text != '' && quantity.text != '') {
              int foodType = constants.foodTypes.indexOf(selectedFoodType);
              FoodItem foodItem = FoodItem(name.text, foodType, foodOpened,
                  foodExpiry, int.parse(quantity.text), measurement);
              FirebaseCRUD.addFoodItem(foodItem, widget.userID);
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const HomePage(0),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else {
              setState(() {
                warning = 'Please ensure the food item has a Name and Quantity';
              });
            }
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
