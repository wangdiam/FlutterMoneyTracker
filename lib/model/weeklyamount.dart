class WeeklyAmount {
  int _id;
  double _amount;

  WeeklyAmount(this._amount);

  WeeklyAmount.map(dynamic obj) {
    this._id = obj['id'];
    this._amount = obj['amount'];
  }

  double get amount => _amount;
  int get id => _id;

  Map<String,dynamic> toMap() {
    var map = new Map<String,dynamic>();
    map['amount'] = _amount;
    if (id != null) {
      map['id'] = _id;
    }
    return map;
  }

  WeeklyAmount.fromMap(Map<String,dynamic> map) {
    this._id = map['id'];
    this._amount = map['amount'];
  }
}