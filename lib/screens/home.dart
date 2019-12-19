import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holidays/screens/createEvent.dart';
import 'package:holidays/util/data.dart';
import 'package:holidays/widgets/holiday_item.dart';

import '../util/const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var listMessage;
  var listHoliday;

  final ScrollController listScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Widget buildHolidayItem(int index, DocumentSnapshot document) {
    return HolidayItem(
        img: "assets/cm${random.nextInt(10)}.jpeg",
        name: document['publicHolidayName'],
        dp: "assets/cm${random.nextInt(10)}.jpeg",
        time: "${random.nextInt(50)} min ago",
        date: document['publicHolidayDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Holidays"),
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
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('holidays')
            .orderBy('publicHolidayDate', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constants.themeColor)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: listMessage.length,
              itemBuilder: (context, index) =>
                  buildHolidayItem(index, snapshot.data.documents[index]),
            );
          }
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
