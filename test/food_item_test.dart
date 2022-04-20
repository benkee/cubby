import 'package:cubby/models/food_item.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  String name = 'name';
  int type = 0;
  bool opened = true;
  DateTime currentTime = DateTime.now();

  FoodItem foodItem = FoodItem(name, type, opened, currentTime);

  test("The food item is initialised correctly", () {
    expect(foodItem.name, name);
    expect(foodItem.type, type);
    expect(foodItem.opened, opened);
    expect(foodItem.expires, currentTime);
  });

  test("Food Items are changed correctly", () {
    String newName = 'newName';
    int newType = 1;
    bool newOpened = false;
    DateTime newCurrentTime = DateTime.now();

    foodItem.setName(newName);
    foodItem.setType(newType);
    foodItem.setOpened(newOpened);
    foodItem.setExpires(newCurrentTime);
    expect(foodItem.name, newName);
    expect(foodItem.type, newType);
    expect(foodItem.opened, newOpened);
    expect(foodItem.expires, newCurrentTime);
  });
}
