import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubby/models/food_item.dart';


// ignore: camel_case_types
class firebaseCRUD {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void addFoodItem(FoodItem foodItem, String userID){
    firestore.collection(userID).add(foodItem.toJson());
  }

  static Future<List<FoodItem>> getFoodItems(String userID) async {
    List<FoodItem> foodItems = [];
    await firestore.collection(userID).get().then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        foodItems.add(FoodItem.fromJson(element.data()));
      }
    });
    return foodItems;
  }

}