import 'package:flutter/material.dart';
import 'package:flutter_chat_app/custom/signInButton.dart';
import 'package:flutter_chat_app/custom/emailLoginWidgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 10),
              EmailLogin(),
              SignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}
