import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatscloneapp/models/Conversation.dart';
import 'package:whatscloneapp/models/Message.dart';
import 'package:whatscloneapp/models/User.dart';
import 'dart:io';
import 'dart:async';

class MessageScreen extends StatefulWidget {
  User contact;
  MessageScreen(this.contact);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  Firestore db = Firestore.instance;
  TextEditingController _controllerMessage = TextEditingController();
  ScrollController _scrollController = ScrollController();

  String idUserIn;
  String idUserRecipient;
  String urlImage;

  bool _upImg = false;

  _sendMessage() {
    String textMessage = _controllerMessage.text;
    if (textMessage.isNotEmpty) {
      Message message = Message();
      message.uid = idUserIn;
      message.message = textMessage;
      message.image = "";
      message.type = "text";
      message.date = Timestamp.now().toString();

      _saveMessage(idUserIn, idUserRecipient, message);
      _saveMessage(idUserRecipient, idUserIn, message);

      _saveConversation(message);
    }
  }

  _saveMessage(String idSender, String idRecipient, Message msg) async {
    await db
        .collection("messages")
        .document(idSender)
        .collection(idRecipient)
        .add(msg.topMap());

    _controllerMessage.clear();
  }

  _saveConversation(Message message) {
    Conversation _senderTalk = Conversation();
    _senderTalk.idSender = idUserIn;
    _senderTalk.idRecipient = idUserRecipient;
    _senderTalk.message = message.message;
    _senderTalk.name = widget.contact.name;
    _senderTalk.photo = widget.contact.photo;
    _senderTalk.type = message.type;
    _senderTalk.create();

    Conversation _recipientTalk = Conversation();
    _recipientTalk.idSender = idUserRecipient;
    _recipientTalk.idRecipient = idUserIn;
    _recipientTalk.message = message.message;
    _recipientTalk.name = widget.contact.name;
    _recipientTalk.photo = widget.contact.photo;
    _recipientTalk.type = message.type;
    _recipientTalk.create();
  }

  _sendPhoto() async {
    File selectedImage;
    _upImg = true;
    selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference rootDir = storage.ref();
    StorageReference file =
        rootDir.child("messages").child(idUserIn).child(imageName + '.jpg');

    StorageUploadTask task = file.putFile(selectedImage);
    task.events.listen((StorageTaskEvent storageTaskEvent) {
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _upImg = true;
        });
      } else if (storageTaskEvent.type == StorageTaskEventType.success) {
        setState(() {
          _upImg = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _getUrlImage(snapshot);
    });
  }

  Future _getUrlImage(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    Message message = Message();
    message.uid = idUserIn;
    message.message = '';
    message.image = url;
    message.type = "image";
    message.date = Timestamp.now().toString();

    _saveMessage(idUserRecipient, idUserIn, message);
    _saveMessage(idUserIn, idUserRecipient, message);
  }

  Future _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userIn = await auth.currentUser();
    idUserIn = userIn.uid;
    idUserRecipient = widget.contact.uid;
    _addListernerMessage();
  }

  Stream<QuerySnapshot> _addListernerMessage() {
    final stream = db
        .collection('messages')
        .document(idUserIn)
        .collection(idUserRecipient)
        .orderBy('date', descending: false)
        .snapshots();
    stream.listen((datas) {
      _controllerStream.add(datas);
      Timer(Duration(seconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerStream.close();
  }

  @override
  Widget build(BuildContext context) {
    var _boxMessage = Container(
      padding: EdgeInsets.all(6.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: TextField(
                controller: _controllerMessage,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 6.0),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  prefixIcon: _upImg
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.camera_alt),
                          color: Color(0xff075e54),
                          onPressed: _sendPhoto,
                        ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075e54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );

    var _stream = StreamBuilder(
      stream: _controllerStream.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text('Carregando mensagens...'),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Expanded(
                child: Center(
                  child: Text('Erro ao carregar mensagens'),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> messages =
                        querySnapshot.documents.toList();
                    DocumentSnapshot item = messages[index];
                    double _containerWidth =
                        MediaQuery.of(context).size.width * .8;
                    Alignment _alignment = Alignment.centerRight;
                    Color _color = Color(0xffd2ffa5);
                    if (idUserIn != item['uid']) {
                      _color = Colors.white;
                      _alignment = Alignment.centerLeft;
                    }

                    return Align(
                      alignment: _alignment,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4.0, 6.0, 4.0, 6.0),
                        child: Container(
                          width: _containerWidth,
                          padding: EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: item['type'] == 'text'
                              ? Text(
                                  item['message'],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                )
                              : Image.network(item['image']),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            break;
          default:
            return Container();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 22,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contact.photo != null
                  ? NetworkImage(widget.contact.photo)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.contact.name),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(6.0),
            child: Column(
              children: <Widget>[
                _stream,
                _boxMessage,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
