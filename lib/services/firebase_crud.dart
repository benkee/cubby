import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_item.dart';

// ignore: camel_case_types
class FirebaseCRUD {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void addFoodItem(FoodItem foodItem, String userID) {
    firestore
        .collection(userID)
        .add(foodItem.toJson())
        .then((value) => foodItem.setID(value.id));
  }

  static Future<List<FoodItem>> getFoodItems(String userID) async {
    List<FoodItem> foodItems = [];
    await firestore.collection(userID).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        FoodItem foodItem = FoodItem.fromJson(document.data());
        foodItems.add(foodItem);
        foodItem.setID(document.id.toString());
      });
    });
    return foodItems;
  }

  static void deleteFoodItem(FoodItem foodItem, String userID) {
    firestore.collection(userID).doc(foodItem.id).delete();
  }

  static void updateFoodItem(
      FoodItem foodItem, String userID, String field, dynamic value) {
    firestore.collection(userID).doc(foodItem.id).update({field: value});
  }
}
