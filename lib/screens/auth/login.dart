import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:holidays/utils/input_validator.dart';
import 'package:holidays/view_model/base.dart';
import 'package:holidays/view_model/user.dart';
import 'package:holidays/view_model/google_button.dart';
import 'package:provider/provider.dart';

import './sign_up.dart';
import '../home.dart';

class Login extends StatefulWidget {
  static const routeName = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TapGestureRecognizer _signUpTapRecognizer;
  final _loginFormKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

  @override
  void initState() {
    super.initState();
    _signUpTapRecognizer = TapGestureRecognizer()..onTap = _handleSignUpTap;
  }

  _handleSignUpTap() {
    Navigator.of(context).pushNamed(SignUp.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          customBorder: CircleBorder(),
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(90, 97, 117, 1),
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Hey! ",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey.shade700,
                                letterSpacing: 1.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 40.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Is that you?",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey.shade700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text('Email'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: TextFormField(
                        validator: InputValidator.email,
                        onSaved: (value) => _formData['email'] = value,
                        cursorColor: Color(0xFF3C4858),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            hintText: 'It\'s-me@mail.com',
                            suffixIcon: Icon(Icons.alternate_email)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text('Password'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: TextFormField(
                        validator: InputValidator.password,
                        onSaved: (value) => _formData['password'] = value,
                        cursorColor: Color(0xFF3C4858),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            hintText: 'Our litte secret',
                            suffixIcon: Icon(Icons.lock_outline)),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      width: 320,
                      height: 60,
                      margin: EdgeInsets.only(top: 40, bottom: 30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF3C4858).withOpacity(.4),
                              offset: Offset(10.0, 10.0),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: RaisedButton(
                        color: Color(0xFF3C4858),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          if (Provider.of<UserViewModel>(context).viewStatus ==
                              ViewStatus.Loading) return;
                          final form = _loginFormKey.currentState;
                          if (form.validate()) {
                            form.save();
                            _handleLogin();
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 40.0),
                                child: Provider.of<UserViewModel>(context)
                                            .viewStatus ==
                                        ViewStatus.Loading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      )
                                    : Text(
                                        'Let\'s go',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                      ),
                              ),
                            ),
                            Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF3C4858),
                                size: 20.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RichText(
                          text: TextSpan(
                              style: Theme.of(context).textTheme.body1,
                              children: [
                            TextSpan(
                              text: 'First time here? ',
                            ),
                            TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(color: Color(0xFF3C4858)),
                                recognizer: _signUpTapRecognizer),
                          ])),
                    ),
                    Container(
                      width: 320,
                      height: 60,
                      margin: EdgeInsets.only(top: 40, bottom: 30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF3C4858).withOpacity(.4),
                              offset: Offset(10.0, 10.0),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: RaisedButton(
                        color: Color(0xFF3C4858),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          _handleGoogleLogin();
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 40.0),
                                child:
                                    Provider.of<GoogleButtonViewModel>(context)
                                                .viewStatus ==
                                            ViewStatus.Loading
                                        ? CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                          )
                                        : Row(
                                            children: <Widget>[
                                              Image(
                                                  image: AssetImage(
                                                      "assets/google_logo.png"),
                                                  height: 30.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 0, 0),
                                                child: Text(
                                                  'Google sign in',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                              ),
                            ),
                            Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF3C4858),
                                size: 20.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _handleLogin() async {
    final response = await Provider.of<UserViewModel>(context, listen: false)
        .signInWithEmailAndPassword(_formData);
    if (response) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName, (Route<dynamic> route) => false);
    }
  }

  void _handleGoogleLogin() async {
    final response =
        await Provider.of<GoogleButtonViewModel>(context, listen: false)
            .signInWithGoogle(_formData);
    if (response) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName, (Route<dynamic> route) => false);
    }
  }

  @override
  void dispose() {
    _signUpTapRecognizer.dispose();
    super.dispose();
  }
}
