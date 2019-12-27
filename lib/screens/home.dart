import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/util/const.dart';
import 'package:holidays/utils/common.dart' show formatDate;
import 'package:holidays/widgets/holiday_item.dart';
import 'package:holidays/widgets/mybottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Random random = Random();

class UserTest {
  static String fullname = "Cybdom Tech",
      profilePicture =
          "https://cdn.pixabay.com/photo/2019/11/19/21/44/animal-4638598_960_720.jpg";
}

class DestinationModel {
  final String placeName, imageUrl, date, hotelName;
  DestinationModel({this.placeName, this.imageUrl, this.date, this.hotelName});
}

final List<DestinationModel> destinationsList = [
  DestinationModel(
    imageUrl:
        "https://cdn.pixabay.com/photo/2017/01/04/21/00/new-years-eve-1953253_960_720.jpg",
  ),
  DestinationModel(
    imageUrl:
        "https://cdn.pixabay.com/photo/2013/02/21/19/06/beach-84533_960_720.jpg",
  ),
  DestinationModel(
    imageUrl:
        "https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg",
  ),
  DestinationModel(
    imageUrl:
        "https://cdn.pixabay.com/photo/2016/09/07/11/37/tropical-1651426_960_720.jpg",
  ),
];

class Home extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Sign out', icon: Icons.vpn_key),
];

class _HomeState extends State<Home> {
  var listHoliday;

  // final String currentUserId;
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  SharedPreferences prefs;

  String currentUserId = '';

  @override
  void initState() {
    super.initState();

    readLocal();
    registerNotification();
    configLocalNotification();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('id') ?? '';
  }

  Widget buildHolidayItem(int index, DocumentSnapshot document) {
    return HolidayItem(
        img:
            "https://cdn.pixabay.com/photo/2019/08/19/15/13/eiffel-tower-4416700_960_720.jpg",
        name: document['publicHolidayName'],
        dp: "https://cdn.pixabay.com/photo/2019/08/19/15/13/eiffel-tower-4416700_960_720.jpg",
        time: "${random.nextInt(50)} min ago",
        date: document['publicHolidayDate']);
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.flatnote.holidays' : 'com.example.holidays',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 70,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "Holidays",
                      style: Theme.of(context).textTheme.display1,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('holidays')
                          .orderBy('publicHolidayDate', descending: true)
                          .limit(20)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Constants.themeColor)));
                        } else {
                          listHoliday = snapshot.data.documents;

                          return Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listHoliday.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // builder: (ctx) => DetailsScreen(id: i),
                                      builder: (ctx) => Scaffold(
                                          body: Container(
                                        child: Center(
                                          child: Text('Detail'),
                                        ),
                                      )),
                                    ),
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 11.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: Image.network(
                                              destinationsList[i %
                                                      destinationsList.length]
                                                  .imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 9.0,
                                                  vertical: 5.0),
                                              decoration: BoxDecoration(
                                                color: Constants.darkBG,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      listHoliday[i]
                                                          ['publicHolidayName'],
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                  Text(
                                                    formatDate(listHoliday[i]
                                                        ['publicHolidayDate']),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle
                                                        .apply(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              height: 70,
              left: 0,
              right: 0,
              child: Container(
                color: Constants.darkBG,
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: MyBottomNavBar(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
