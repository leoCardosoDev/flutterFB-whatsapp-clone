import 'package:flutter/material.dart';
import 'package:whatscloneapp/models/Conversation.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  List<Conversation> listTalk = [
    Conversation("Leonardo Cardoso", "Olá Priscila! Tudo Bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-ed3d4.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=efd21a05-71c9-4456-876f-794543c0ae8d"),
    Conversation("Priscila ", "Oi Leozinho meu amor! Estou bem e você?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-ed3d4.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=823de68b-f8de-48b4-8f13-8903bee2e27b"),
    Conversation("Joao Maria", "Ei main",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-ed3d4.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=9b8a8c0a-fe0c-4e4a-8ccb-8138b695e894"),
    Conversation("José Felipe", "Hello World",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-ed3d4.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=33717346-59bb-43b4-a9bf-7778c6e5d930"),
    Conversation("Kamila Camila", "Hello World",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-ed3d4.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=1f9f8977-70ca-4412-b912-fffd5eefa978"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listTalk.length,
        itemBuilder: (context, index) {
          Conversation talk = listTalk[index];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 6.0),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(talk.photo),
            ),
            title: Text(
              talk.name,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
