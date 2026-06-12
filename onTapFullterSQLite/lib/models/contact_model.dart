class Contact_AuDuongTan {
  int? _id;
  late String _name;
  late String _number;
  String? _email;
  String? _groupName;
  String? _gender;

  // Constructor
  Contact_AuDuongTan({
    int? id,
    required String name,
    required String number,
    String? email,
    String? groupName,
    String? gender,
  }) {
    _id = id;
    _name = name;
    _number = number;
    _email = email;
    _groupName = groupName;
    _gender = gender;
  }

  // Getters
  int? get id => _id;
  String get name => _name;
  String get number => _number;
  String? get email => _email;
  String? get groupName => _groupName;
  String? get gender => _gender;

  // Setters
  set id(int? value) => _id = value;
  set name(String value) => _name = value;
  set number(String value) => _number = value;
  set email(String? value) => _email = value;
  set groupName(String? value) => _groupName = value;
  set gender(String? value) => _gender = value;

  // Chuyển đối tượng thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': _name,
      'number': _number,
      'email': _email,
      'group_name': _groupName,
      'gender': _gender,
    };
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  // Tạo đối tượng từ Map lấy ra từ SQLite
  Contact_AuDuongTan.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _number = map['number'];
    _email = map['email'];
    _groupName = map['group_name'];
    _gender = map['gender'];
  }
}
