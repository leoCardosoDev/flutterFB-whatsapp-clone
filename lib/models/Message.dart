class Message {
  String _uid;
  String _message;
  String _image;
  String _type;

  Message();

  Map<String, dynamic> topMap() {
    Map<String, dynamic> map = {
      "uid": this.uid,
      "message": this.message,
      "image": this.image,
      "type": this.type
    };

    return map;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }
}
