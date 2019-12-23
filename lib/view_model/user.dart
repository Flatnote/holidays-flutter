import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:holidays/models/user.dart';
import 'package:holidays/services/dialog_service.dart';
import 'package:holidays/services/locator.dart';
import 'package:holidays/view_model/base.dart';
import 'package:holidays/services/auth_service.dart';

const ERROR_MESSAGE = "😥 Something went wrong. Please try again later!";

class UserViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();

  String _message;
  User _userProfile;

  String get message => _message;

  User get userProfile => _userProfile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> create(Map<String, String> formData) async {
    setStatus(ViewStatus.Loading);
    Response response;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: formData['email'], password: formData['password']);
      setStatus(ViewStatus.Ready);
      await _dialogService
          .showAlertDialog("Yay! Your account has been created. Continue!");
    } on DioError catch (e) {
      final data = e.response?.data ?? {};
      final message = data['message'] ?? ERROR_MESSAGE;
      setStatus(ViewStatus.Ready);
      _dialogService.showAlertDialog(message);
    }

    return response?.statusCode == 201;
  }

  // sign in with email and password
  Future<bool> signInWithEmailAndPassword(Map<String, String> formData) async {
    setStatus(ViewStatus.Loading);
    FirebaseUser user;
    try {
      user = await AuthService()
          .signInWithEmailAndPassword(formData['email'], formData['password']);
    } on PlatformException catch (error) {
      print(error.message);
      _dialogService.showAlertDialog(error.message);
    }
    setStatus(ViewStatus.Ready);

    return user != null;
  }
}
