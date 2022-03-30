import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/crud.dart';
import '../../widgets/fooditemcard.dart';

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
                return FoodItemCard(foodItem: foodItems[index]);
              });
        }
      },
      future: FirebaseCRUD.getFoodItems(
          FirebaseAuth.instance.currentUser?.uid.toString() ?? ''),
    );
  }
}
