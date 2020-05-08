import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/models/User.dart';
import 'package:whatscloneapp/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  TextEditingController _controllerName =
      TextEditingController();
  TextEditingController _controllerEmail =
      TextEditingController();
  TextEditingController _controllerPassword =
      TextEditingController();

  String _messageError = "";

  // Validate
  void _validateFields() {
    // Recuperar dados do campos
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (name.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        //
        if (password.isNotEmpty && password.length >= 6) {
          //
          setState(() {
            _messageError = "";
          });

          User user = User();
          user.name = name;
          user.email = email;
          user.password = password;

          _registerUsers(user);
        } else {
          setState(() {
            _messageError =
                "A senha não pode estar vazia e precisa conter 6 ou mais caracteres ";
          });
        }
      } else {
        setState(() {
          _messageError =
              "O E-mail não pode estar vazio e precisa ser um e-mail válido ";
        });
      }
      //
    } else {
      setState(() {
        _messageError =
            "O nome não pode estar vazio e precisa ter mais de 3 caracteres";
      });
    }
  }

  // Cadastrar Usuários
  _registerUsers(User user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((firebaseUser) {

          Firestore db = Firestore.instance;

          db.collection('users')
          .document(firebaseUser.user.uid)
          .setData(user.toMap());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }).catchError((error) {
      setState(() {
        _messageError = "Erro ao cadastrar " + error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastre-se"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075e54)),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 28.0),
                  child: Image.asset(
                    "assets/images/usuario.png",
                    width: 150.0,
                    height: 100.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                      hintText: "Nome Completo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: _controllerPassword,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    onPressed: () {
                      _validateFields();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _messageError,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    ),
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
