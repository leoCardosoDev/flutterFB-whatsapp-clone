import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController _controllerName = TextEditingController();

  File _image;
  String _idUserIn;
  String _urlImage;
  bool _upImage = false;

  Future _recoveryImage(String originImage) async {
    File imageSelected;

    switch (originImage) {
      case 'camera':
        imageSelected = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case 'gallery':
        imageSelected =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _image = imageSelected;
      if (_image != null) {
        _upImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference rootDir = storage.ref();
    StorageReference file =
        rootDir.child('perfil').child(_idUserIn + '_perfil.jpg');

    StorageUploadTask task = file.putFile(_image);
    task.events.listen((StorageTaskEvent storageTaskEvent) {
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _upImage = true;
        });
      } else if (storageTaskEvent.type == StorageTaskEventType.success) {
        setState(() {
          _upImage = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _getUrlImage(snapshot);
    }).catchError((error) {});
  }

  Future _getUrlImage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    _updateUrlImage(url);

    setState(() {
      _urlImage = url;
    });
  }

  _updateUrlImage(String url) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> dataUpadated = {'urlPerfilImage': url};

    db.collection('users').document(_idUserIn).updateData(dataUpadated);
  }

  _updateUserName() {
    Firestore db = Firestore.instance;

    Map<String, dynamic> dataUpadated = {'name': _controllerName.text};

    db.collection('users').document(_idUserIn).updateData(dataUpadated);
  }

  Future _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userIn = await auth.currentUser();
    _idUserIn = userIn.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection('users').document(_idUserIn).get();

    Map<String, dynamic> data = snapshot.data;
    _controllerName.text = data['name'];

    if (data['urlPerfilImage'] != null) {
      setState(() {
        _urlImage = data['urlPerfilImage'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Container(
        padding: EdgeInsets.all(14.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(14.0),
                  child: _upImage ? CircularProgressIndicator() : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      _urlImage != null ? NetworkImage(_urlImage) : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Câmera'),
                      onPressed: () {
                        _recoveryImage('camera');
                      },
                    ),
                    FlatButton(
                      child: Text('Galeria'),
                      onPressed: () {
                        _recoveryImage('gallery');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(30.0, 14.0, 30.0, 14.0),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 14.0, bottom: 8.0),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(30.0, 14.0, 30.0, 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: _updateUserName,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
