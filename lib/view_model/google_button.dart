import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:holidays/models/user.dart';
import 'package:holidays/services/dialog_service.dart';
import 'package:holidays/services/locator.dart';
import 'package:holidays/view_model/base.dart';

const ERROR_MESSAGE = "😥 Something went wrong. Please try again later!";

class GoogleButtonViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();

  String _message;
  User _userProfile;

  String get message => _message;

  User get userProfile => _userProfile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // sign in with email and password
  Future<bool> signInWithGoogle(Map<String, String> formData) async {
    setStatus(ViewStatus.Loading);
    FirebaseUser user;
    try {
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
    } on PlatformException catch (error) {
      print(error.message);
      _dialogService.showAlertDialog(error.message);
    }
    setStatus(ViewStatus.Ready);

    return user != null;
  }
}
