import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/crud.dart';

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none) {
          print('project snapshot data is: ${projectSnap.data}');
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (projectSnap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: (projectSnap.data as List<FoodItem>).length,
              itemBuilder: (context, index) {
                List<FoodItem> foodItems = projectSnap.data as List<FoodItem>;
                return foodItemCard(foodItems[index]);
              });
        }
      },
      future: FirebaseCRUD.getFoodItems(
          FirebaseAuth.instance.currentUser?.uid.toString() ?? ''),
    );
  }

  Widget foodItemCard(FoodItem foodItem) {
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
            child: foodName(foodItem)));
  }
}

Widget foodName(FoodItem item) {
  return Align(
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
            text: item.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: item.foodTypes[item.type],
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ))
            ]),
      ));
}
