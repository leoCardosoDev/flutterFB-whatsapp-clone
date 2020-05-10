import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/models/User.dart';
import 'package:whatscloneapp/routes/RouteGenerator.dart';

class ConversationTab extends StatefulWidget {
  @override
  _ConversaTabState createState() => _ConversaTabState();
}

class _ConversaTabState extends State<ConversationTab> {

  Firestore db = Firestore.instance;
  String idUserIn;
  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> addListenerConversation(){
    final stream = db
        .collection('conversations')
        .document(idUserIn)
        .collection('lastConversation')
        .snapshots();

    stream.listen((datas){
      _controllerStream.add(datas);
    });
  }

  Future _getDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userIn = await auth.currentUser();
    idUserIn = userIn.uid;
    addListenerConversation();
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

    return StreamBuilder<QuerySnapshot>(
      stream: _controllerStream.stream,
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Carregando conversas...'),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          default:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Center(
                  child: Text('Erro ao carregar mensagens'),
              );
            }else {
              if(querySnapshot.documents.length == 0){
                return Center(
                  child: Text("Você não tem nenhuma conversa :( "),
                );
              }
                return ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {

                      List<DocumentSnapshot> conversations = querySnapshot.documents.toList();
                      DocumentSnapshot talk = conversations[index];
                      User user = User();
                      user.name = talk['name'];
                      user.photo = talk['photo'];
                      user.uid = talk['idRecipient'];

                      return ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, RouteGenerator.ROUTE_MESSAGE, arguments: user);
                        },
                        contentPadding: EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 6.0),
                        leading: CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: talk['photo'] != null ? NetworkImage(talk['photo']) : null,
                        ),
                        title: Text(
                          talk['name'],
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          talk['type'] == 'image' ? 'Foto' : talk['message'],
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      );
                });
            }
        } //fim switch
      },
    );

  }
}
