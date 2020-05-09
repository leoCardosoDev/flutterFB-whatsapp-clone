import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatscloneapp/models/User.dart';
import 'package:whatscloneapp/routes/RouteGenerator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controllerEmail =
      TextEditingController(text: "leocardosodev@gmail.com");
  TextEditingController _controllerPassword =
      TextEditingController(text: "12345678");

  String _messageError = "";

  // Validate
  void _validateFields() {
    // Recuperar dados do campos
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      //
      if (password.isNotEmpty) {
        //
        setState(() {
          _messageError = "";
        });

        User user = User();
        user.email = email;
        user.password = password;

        _loginUsers(user);
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
  }

  _loginUsers(User user) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_HOME);
    }).catchError((error) {
      setState(() {
        _messageError =
            "Erro ao autenticar usuário! Verifique se e-mail e senha estão corretos";
      });
    });
  }

  Future _verifierUserLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser _userLogin = await auth.currentUser();

    if (_userLogin != null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_HOME);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifierUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'assets/images/logo.png',
                    width: 150.0,
                    height: 100.0,
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
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
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
                      "Entrar",
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
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      _messageError,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
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
