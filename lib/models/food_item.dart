import 'package:flutter/material.dart';

class FoodItem {
  List<String> foodTypes = [
    'Fruit',
    'Vegetable',
    'Meat',
    'Tinned',
    'Dairy',
    'Frozen'
  ];

  final String _id = UniqueKey().toString();
  String _name;
  int _type;

  FoodItem(
    this._name,
    this._type,
  );

  String get id => _id;
  String get name => _name;
  int get type => _type;

  set setName(String name) {
    _name = name;
  }

  set setType(int type) {
    _type = type;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }

  FoodItem.fromJson(Map<String, dynamic> json)
      : this(json['name'] as String, json['type'] as int);
}
