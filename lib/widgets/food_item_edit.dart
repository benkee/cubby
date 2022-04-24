import 'package:cubby/constants/constants.dart' as constants;
import 'package:cubby/views/home/home.dart';
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';

class FoodItemEdit extends StatefulWidget {
  late FoodItem foodItem;
  late String userID;
  FoodItemEdit({required this.foodItem, required this.userID, Key? key})
      : super(key: key);

  @override
  _FoodItemInputState createState() => _FoodItemInputState();
}

class _FoodItemInputState extends State<FoodItemEdit> {
  final name = TextEditingController();
  final quantity = TextEditingController();
  late String selectedFoodType =
      constants.foodTypes.elementAt(widget.foodItem.type);
  late DateTime foodExpiry = widget.foodItem.expires;
  late bool foodOpened = widget.foodItem.opened;
  late int measurement = widget.foodItem.measurement;

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
        'Edit Food Item:',
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: widget.foodItem.name,
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
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantity,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: widget.foodItem.quantity.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  SizedBox(
                    width: 70,
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
              )
            ]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            int foodType = constants.foodTypes.indexOf(selectedFoodType);
            updateFoodItem(widget.foodItem, name.text, foodType, foodOpened,
                foodExpiry, quantity.text, measurement);

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage(0)));
          },
          child: const Text('Edit Item', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(0),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void updateFoodItem(
    FoodItem foodItem,
    String name,
    int foodType,
    bool foodOpened,
    DateTime foodExpiry,
    String quantity,
    int measurement,
  ) {
    if (foodItem.name != name && name != '') {
      FirebaseCRUD.updateFoodItem(widget.foodItem, 'name', name, widget.userID);
    }
    if (foodItem.type != foodType) {
      FirebaseCRUD.updateFoodItem(
          widget.foodItem, 'type', foodType, widget.userID);
    }
    if (foodItem.opened != foodOpened) {
      FirebaseCRUD.updateFoodItem(
          widget.foodItem, 'opened', foodOpened, widget.userID);
    }
    if (foodItem.expires != foodExpiry) {
      FirebaseCRUD.updateFoodItem(
          widget.foodItem, 'expires', foodExpiry, widget.userID);
    }
    if(quantity != ''){
      FirebaseCRUD.updateFoodItem(
          widget.foodItem, 'quantity', int.parse(quantity), widget.userID);
    }
    FirebaseCRUD.updateFoodItem(
        widget.foodItem, 'measurement', measurement, widget.userID);
  }
}
