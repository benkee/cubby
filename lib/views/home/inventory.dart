import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';
import '../widgets/food_item_card.dart';
import '../widgets/food_item_input.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);
  getState() => _InventoryPageState();
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
          if (projectSnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (projectSnap.hasError) {
            return Center(
              child: Text('Error gathering data: ${projectSnap.error}'),
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
        future: FirebaseCRUD.getFoodItems(),
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
