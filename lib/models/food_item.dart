class FoodItem {
  String _id = '';
  String _name;
  int _type;
  bool _opened;
  DateTime _expires;
  int _quantity;
  int _measurement;

  FoodItem(
    this._name,
    this._type,
    this._opened,
    this._expires,
    this._quantity,
    this._measurement,
  );

  String get id => _id;
  String get name => _name;
  int get type => _type;
  bool get opened => _opened;
  DateTime get expires => _expires;
  int get quantity => _quantity;
  int get measurement => _measurement;

  setID(String id) {
    _id = id;
  }

  setName(String name) {
    _name = name;
  }

  setType(int type) {
    _type = type;
  }

  setOpened(bool opened) {
    _opened = opened;
  }

  setExpires(DateTime expires) {
    _expires = expires;
  }

  setQuantity(int quantity) {
    _quantity = quantity;
  }

  setMeasurement(int measurement) {
    _measurement = measurement;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'type': _type,
      'opened': _opened,
      'expires': _expires,
      'quantity': _quantity,
      'measurement': _measurement,
    };
  }

  FoodItem.fromJson(Map<String, dynamic> json)
      : this(
          json['name'] as String,
          json['type'] as int,
          json['opened'] as bool,
          json['expires'].toDate() as DateTime,
          json['quantity'] as int,
          json['measurement'] as int,
        );
}
