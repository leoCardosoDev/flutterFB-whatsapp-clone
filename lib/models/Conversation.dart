
class Conversation{

  String _name;
  String _message;
  String _photo;


  Conversation(this._name, this._message, this._photo);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  set message(String value) {
    _message = value;
  }

}