class Entry {
  int _id;
  String _title;
  String _description;
  double _amount;
  int _time;
  
  Entry(this._title,this._description,this._amount,this._time);
  
  Entry.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._amount = obj['amount'];
    this._time = obj['time'];
    
  }
  
  String get title => _title;
  String get description => _description;
  double get amount => _amount;
  int get time => _time;
  int get id => _id;

  Map<String,dynamic> toMap() {
    var map = new Map<String,dynamic>();
    map['title'] = _title;
    map['description'] = _description;
    map['amount'] = _amount;
    map['time'] = _time;

    if (id != null) {
      map['id'] = _id;
    }
    return map;
  }

  Entry.fromMap(Map<String,dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._amount = map['amount'];
    this._time = map['time'];
  }
}