class RegistryData {
  String _fullName;
  String _address;
  int _state;
  String _phone;
  String _email;
  String _username;
  String _password;

  RegistryData() {
    _fullName = "";
    _address = "";
    _state = 1;
    _phone = "";
    _email = "";
    _username = "";
    _password = "";
  }

  RegistryData.fromMap(map) {
    this._fullName = map["fullName"];
    this._address = map["address"];
    this._state = map["state"];
    this._phone = map["phone"];
    this._email = map["email"];
    this._username = map["username"];
    this._password = map["password"];
  }

  String get fullName => _fullName;
  String get address => _address;
  int get state => _state;
  String get phone => _phone;
  String get email => _email;
  String get username => _username;
  String get password => _password;

  set fullName(String newFullName) {
    if (newFullName.length > 0) {
      this._fullName = newFullName;
    }
  }

  set address(String newAddress) {
    if (newAddress.length > 0) {
      this._address = newAddress;
    }
  }

  set state(int newState) {
    if (newState > 0 && newState < 4) {
      this._state = newState;
    }
  }

  set phone(String newPhone) {
    if (newPhone.length > 0) {
      this._phone = newPhone;
    }
  }

  set email(String newEmail) {
    if (newEmail.length > 0) {
      this._email = newEmail;
    }
  }

  set username(String newUsername) {
    if (newUsername.length > 0) {
      this._username = newUsername;
    }
  }

  set password(String newPassword) {
    if (newPassword.length > 0) {
      this._password = newPassword;
    }
  }

  toMap() {
    var map = Map<String, dynamic>();
    map["fullName"] = _fullName;
    map["address"] = _address;
    map["state"] = _state;
    map["phone"] = _phone;
    map["email"] = _email;
    map["username"] = _username;
    map["password"] = _password;
    return map;
  }

  printer() {
    print("fullName: $_fullName");
    print("address: $_address");
    print("state: $_state");
    print("phone: $_phone");
    print("email: $_email");
    print("username: $_username");
    print("password: $_password");
  }
}