import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/models/Message.dart';
import 'package:whatscloneapp/models/User.dart';

class MessageScreen extends StatefulWidget {
  User contact;
  MessageScreen(this.contact);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  Firestore db = Firestore.instance;
  TextEditingController _controllerMessage = TextEditingController();

  String idUserIn;
  String idUserRecipient;

  _sendMessage() {
    String textMessage = _controllerMessage.text;
    if(textMessage.isNotEmpty){
      Message message = Message();
      message.uid = idUserIn;
      message.message = textMessage;
      message.image = "";
      message.type = "text";

      _saveMessage(idUserRecipient, idUserIn, message);
      _saveMessage(idUserIn, idUserRecipient, message);
    }
  }

  _saveMessage(String idSender, String idRecipient, Message msg) async {
    await db.collection("messages")
    .document(idSender)
    .collection(idRecipient)
    .add(msg.topMap());

    _controllerMessage.clear();

  }

  _sendPhoto() {}

  Future _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userIn = await auth.currentUser();
    idUserIn = userIn.uid;
    idUserRecipient = widget.contact.uid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataUser();
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
                autofocus: true,
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
                  prefixIcon: IconButton(
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
      stream: db.collection('messages').document(idUserIn).collection(idUserRecipient).snapshots(),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
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
            if(snapshot.hasError){
              return Expanded(
                child: Center(
                  child: Text('Erro ao carregar mensagens'),
                ),
              );
            }else{
              return Expanded(
                child: ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> messages = querySnapshot.documents.toList();
                    DocumentSnapshot item = messages[index];
                    double _containerWidth = MediaQuery.of(context).size.width * .8;
                    Alignment _alignment = Alignment.centerRight;
                    Color _color = Color(0xffd2ffa5);
                    if(idUserIn != item['uid']){
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
                            borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: Text(
                            item['message'],
                            style: TextStyle(fontSize: 18.0,),
                          ),
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
              backgroundImage: widget.contact.photo != null ? NetworkImage(widget.contact.photo) : null,
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
