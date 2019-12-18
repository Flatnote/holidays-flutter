import 'package:flutter/material.dart';
import 'package:holidays/screens/createEvent.dart';
import 'package:holidays/util/data.dart';
import 'package:holidays/widgets/post_item.dart';

import '../util/const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feeds"),
        centerTitle: true,
        leading: new Icon(Icons.camera_alt),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return PostItem(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.themeColor,
        child: Icon(
          Icons.add,
          color: Constants.darkBG,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEvent()),
          );
        },
      ),
    );
  }
}
