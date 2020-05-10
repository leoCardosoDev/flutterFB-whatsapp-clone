class Message {
  String _uid;
  String _message;
  String _image;
  String _type;
  String _date;

  Message();

  Map<String, dynamic> topMap() {
    Map<String, dynamic> map = {
      "uid": this.uid,
      "message": this.message,
      "image": this.image,
      "type": this.type,
      "date": this.date
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

  String get date => _date;

  set date(String value) {
    _date = value;
  }


}
