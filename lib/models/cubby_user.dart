class CubbyUser {
  final String _id;
  String _name = '';
  int _foodUsed = 1;
  int _foodWasted = 0;
  bool _newUser = true;

  CubbyUser(
      this._id, this._name, this._foodUsed, this._foodWasted, this._newUser);

  String get id => _id;
  String get name => _name;
  int get foodUsed => _foodUsed;
  int get foodWasted => _foodWasted;
  bool get newUser => _newUser;

  String get percentWasted {
    if (((_foodWasted / _foodUsed) * 100) > 100) {
      return '100.0';
    } else {
      return ((_foodWasted / _foodUsed) * 100).toStringAsPrecision(4);
    }
  }

  setName(String name) {
    _name = name;
  }

  setFoodUsed(int foodUsed) {
    _foodUsed = foodUsed;
  }

  setFoodWasted(int foodWasted) {
    _foodWasted = foodWasted;
  }

  increaseFoodUsed(int amount) {
    _foodUsed += amount;
  }

  increaseFoodWasted(int amount) {
    _foodWasted += amount;
  }

  removeNewUserStatus() {
    _newUser = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'foodUsed': _foodUsed,
      'foodWasted': _foodWasted,
      'newUser': _newUser,
    };
  }

  CubbyUser.fromJson(Map<String, dynamic> json)
      : this(
          json['id'] as String,
          json['name'] as String,
          json['foodUsed'] as int,
          json['foodWasted'] as int,
          json['newUser'] as bool,
        );
}
