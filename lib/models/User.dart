
class User{

  String _uid;
  String _name;
  String _email;
  String _password;
  String _photo;


  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name" : this.name,
      "email" : this.email
    };

    return map;
  }


  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

}