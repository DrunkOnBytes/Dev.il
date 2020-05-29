import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:flutter_chat_app/pages/activeUsersPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {

  String email;
  String password;
  bool _isLoginForm = true;

  final _formKey = new GlobalKey<FormState>();


  Widget emailInput(){
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget passwordInput(){
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => password = value.trim(),
      ),
    );
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void onError(){
    final snackBar = SnackBar(
        content: Text('Login Error. TRY AFTER SOME TIME!')
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void signUpOrLogin() async{

    if(validateAndSave()){

      FirebaseUser user;

      try {

        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (_isLoginForm){

            user = await signInWithEmailAndPassword(email, password);
            if (user.email!=null){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ActiveUsersPage();
                  },
                ),
              ).then((value) => _formKey.currentState.reset())
                  .catchError(onError);
            }
          }
          else{

            user = await createUserWithEmailAndPassword(email, password);
            if (user.email!=null){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ActiveUsersPage();
                  },
                ),
              ).then((value) => _formKey.currentState.reset())
                  .catchError(onError);
            }
          }
        }
      } on SocketException catch (_) {
        final snackBar = SnackBar(
            content: Text('No Internet Connection. TRY AGAIN!')
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget primaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed:(){
              if(_formKey.currentState.validate())
                signUpOrLogin();
            },
          ),
        ));
  }

  Widget secondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  void toggleFormMode() {
    _formKey.currentState.reset();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        shrinkWrap: true,
        children: <Widget>[
          emailInput(),
          passwordInput(),
          primaryButton(),
          secondaryButton(),
        ],
      ),

    );
  }
}

