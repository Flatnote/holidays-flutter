import 'package:flutter/material.dart';
import 'package:holidays/models/user.dart';
import 'package:holidays/screens/chats/old_chats.dart';
import 'package:holidays/screens/profile.dart';
import 'package:provider/provider.dart';

import './mybottomnavbaritem.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _active = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MyBottomNavBarItem(
          active: _active,
          id: 0,
          icon: Icons.home,
          text: "Home",
          function: () {
            setState(() {
              _active = 0;
            });
          },
        ),
        MyBottomNavBarItem(
          active: _active,
          id: 1,
          icon: Icons.chat,
          text: "Chat",
          function: () {
            setState(() {
              _active = 1;
            });
            final user = Provider.of<User>(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => OldChats(
                      currentUserId: user.uid,
                    )));
          },
        ),
        MyBottomNavBarItem(
          active: _active,
          id: 2,
          icon: Icons.person,
          text: "Profile",
          function: () {
            setState(() {
              _active = 2;
            });
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Profile()));
          },
        ),
      ],
    );
  }
}
