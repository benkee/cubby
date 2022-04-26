class Recipe {
  String _id = '';
  String _name;
  List<dynamic> _ingredients;
  int _preparationTime;
  List<dynamic> _instructions;
  double _cost;

  Recipe(this._name, this._ingredients, this._preparationTime,
      this._instructions, this._cost);

  String get id => _id;
  String get name => _name;
  List<dynamic> get ingredients => _ingredients;
  int get preparationTime => _preparationTime;
  List<dynamic> get instructions => _instructions;
  double get cost => _cost;

  setID(String id) {
    _id = id;
  }

  setName(String name) {
    _name = name;
  }

  setIngredients(List<dynamic> ingredients) {
    _ingredients = ingredients;
  }

  setPreparationTime(int preparationTime) {
    _preparationTime = preparationTime;
  }

  setInstructions(List<dynamic> instructions) {
    _instructions = instructions;
  }

  setCost(double cost) {
    _cost = cost;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'ingredients': _ingredients,
      'preparationTime': _preparationTime,
      'instructions': _instructions,
      'cost': _cost,
    };
  }

  Recipe.fromJson(Map<String, dynamic> json)
      : this(
            json['name'] as String,
            json['ingredients'] as List<dynamic>,
            json['preparationTime'] as int,
            json['instructions'] as List<dynamic>,
            json['cost'] as double);
}
