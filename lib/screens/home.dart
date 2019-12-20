import 'package:flutter/material.dart';
import 'package:holidays/models/user.dart';
import 'package:holidays/screens/intro/intro.dart';
import 'package:holidays/services/auth_service.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("This is a home",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(0xFF3C4858),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        final user = Provider.of<User>(context);
        var signOutComplete = await AuthService().signOut(user.type);
        if (signOutComplete != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Intro.routeName, (Route<dynamic> route) => false);
        }
      },
      child: Text(
        'LOG OUT',
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
