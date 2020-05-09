import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/routes/RouteGenerator.dart';
import 'package:whatscloneapp/screens/tabs/contacts_tab.dart';
import 'package:whatscloneapp/screens/tabs/conversation_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

  List<String> _itensMenu = [
    "Configurações", "Sair"
  ];

  String _emailUser = "";

  Future _getCurrentUser() async {


    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser _userLogin = await auth.currentUser();

    setState(() {
      _emailUser = _userLogin.email;
    });

  }

  _selectMenuItem (String selectedItem){
    switch(selectedItem){
      case "Configurações":
        Navigator.pushNamed(context, RouteGenerator.ROUTE_CONFIG);
        break;
      case "Sair":
        _logoutUser();
        break;
    }
  }

  _logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_LOGIN);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentUser();

    _tabController = TabController(
      length: 2,
      vsync: this
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whatsapp"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _selectMenuItem,
            itemBuilder: (context){
              return _itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ConversationTab(),
          ContactsTab(),
        ],
      ),
    );
  }
}
