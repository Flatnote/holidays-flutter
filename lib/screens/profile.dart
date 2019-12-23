import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/const.dart';
import 'package:holidays/screens/intro/intro.dart';
import 'package:holidays/services/auth_service.dart';
import 'package:holidays/view_model/base.dart';
import 'package:holidays/view_model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  static const routeName = 'profile';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
        centerTitle: true,
      ),
      body: new ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State createState() => new ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = new FocusNode();
  final FocusNode focusNodeAboutMe = new FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';
    aboutMe = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';

    controllerNickname = new TextEditingController(text: nickname);
    controllerAboutMe = new TextEditingController(text: aboutMe);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance.collection('users').document(id).updateData({
            'nickname': nickname,
            'aboutMe': aboutMe,
            'photoUrl': photoUrl
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('users').document(id).updateData({
      'nickname': nickname,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl
    }).then((data) async {
      await prefs.setString('nickname', nickname);
      await prefs.setString('aboutMe', aboutMe);
      await prefs.setString('photoUrl', photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 90.0,
                                    height: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: greyColor,
                                ))
                          : Material(
                              child: Image.file(
                                avatarImageFile,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: greyColor,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Nickname',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Sweetie',
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Fun, like travel and play PES...',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: RaisedButton(
                  color: Color(0xFF3C4858),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: handleUpdateData,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: Text(
                    'UPDATE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
              Container(
                child: LogoutButton(),
              )
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}

class UpdateButton extends StatelessWidget {
  void _handleLogin() async {
    // final response = await Provider.of<UserViewModel>(context, listen: false)
    //     .signInWithEmailAndPassword(_formData);
    // if (response) {
    //   Navigator.of(context).pushNamedAndRemoveUntil(
    //       Home.routeName, (Route<dynamic> route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () {
          if (Provider.of<UserViewModel>(context).viewStatus ==
              ViewStatus.Loading) return;
          _handleLogin();
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 40.0),
                child: Provider.of<UserViewModel>(context).viewStatus ==
                        ViewStatus.Loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
              ),
            ),
            Container(
              height: 40.0,
              width: 40.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFF3C4858),
                size: 20.0,
              ),
            )
          ],
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
        var signOutComplete = await AuthService().signOut();
        if (signOutComplete != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Intro.routeName, (Route<dynamic> route) => false);
        }
      },
      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      child: Text(
        'LOG OUT',
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
