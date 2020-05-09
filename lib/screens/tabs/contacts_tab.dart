import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/models/User.dart';
import 'package:whatscloneapp/routes/RouteGenerator.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {

  String _idUserIn;
  String _emailUserIn;

  Future _getUserIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userIn = await auth.currentUser();
    _idUserIn = userIn.uid;
    _emailUserIn = userIn.email;
  }

  Future<List<User>> _getContacts() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection('users').getDocuments();

    List<User> userList = List();
    for (DocumentSnapshot item in querySnapshot.documents) {

      var userData = item.data;
      if(userData['email'] == _emailUserIn) continue;

      User user = User();
      user.uid = item.documentID;
      user.email = userData['email'];
      user.name = userData['name'];
      user.photo = userData['photo'];

      userList.add(user);
    }

    return userList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _getContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Carregando contatos..."),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          default:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  List<User> listItem = snapshot.data;
                  User user = listItem[index];

                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          RouteGenerator.ROUTE_MESSAGE,
                        arguments: user
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 6.0),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          user.photo != null ? NetworkImage(user.photo) : null,
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  );
            });
        }
      },
    );
  }
}
