import 'package:flutter/material.dart';
import 'package:holidays/models/user.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'intro/intro.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Intro();
    }
    return Home();
  }
}
