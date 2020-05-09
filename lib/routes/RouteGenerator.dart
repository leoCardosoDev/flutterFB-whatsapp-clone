import 'package:flutter/material.dart';
import 'package:whatscloneapp/screens/config_screen.dart';
import 'package:whatscloneapp/screens/home_screen.dart';
import 'package:whatscloneapp/screens/login_screen.dart';
import 'package:whatscloneapp/screens/register_screen.dart';

class RouteGenerator {
  static const String ROUTE_BASE = "/";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_REGISTER = "/register";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_CONFIG = "/config";

  static Route<dynamic> generatorRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_BASE:
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;

      case ROUTE_LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;

      case ROUTE_REGISTER:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
        break;

      case ROUTE_HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;

      case ROUTE_CONFIG:
        return MaterialPageRoute(builder: (_) => ConfigScreen());
        break;

      default:
        _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
