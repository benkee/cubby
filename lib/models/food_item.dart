class FoodItem {
  String _id = '';
  String _name;
  int _type;
  bool _opened;
  DateTime _expires;

  FoodItem(
    this._name,
    this._type,
    this._opened,
    this._expires,
  );

  String get id => _id;
  String get name => _name;
  int get type => _type;
  bool get opened => _opened;
  DateTime get expires => _expires;

  setID(String id) {
    _id = id;
  }

  set setName(String name) {
    _name = name;
  }

  set setType(int type) {
    _type = type;
  }

  set setOpened(bool opened) {
    _opened = opened;
  }

  set setExpires(DateTime expires) {
    _expires = expires;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'type': _type,
      'opened': _opened,
      'expires': _expires,
    };
  }

  FoodItem.fromJson(Map<String, dynamic> json)
      : this(json['name'] as String, json['type'] as int,
            json['opened'] as bool, json['expires'].toDate() as DateTime);
}
