import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String _idSender;
  String _idRecipient;
  String _name;
  String _message;
  String _photo;
  String _type;

  Conversation();

  create() async {
    Firestore db = Firestore.instance;
    await db
        .collection('conversations')
        .document(this.idSender)
        .collection('lastConversation')
        .document(this._idRecipient)
        .setData(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idSender": this.idSender,
      "idRecipient": this.idRecipient,
      "name": this.name,
      "message": this.message,
      "photo": this.photo,
      "type": this.type
    };

    return map;
  }

  String get idSender => _idSender;

  set idSender(String value) {
    _idSender = value;
  }

  String get idRecipient => _idRecipient;

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  set idRecipient(String value) {
    _idRecipient = value;
  }
}
