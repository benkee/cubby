import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/crud.dart';
import '../widgets/food_item_card.dart';
import '../widgets/food_item_input.dart';

class InventoryPage extends StatefulWidget {
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none) {
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => FoodItemInput(),
          );
        },
      ),
    );
  }
}
