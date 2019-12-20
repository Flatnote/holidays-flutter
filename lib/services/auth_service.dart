import 'package:firebase_auth/firebase_auth.dart';
import 'package:holidays/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // create user obj based on firebase user
  User _userFromMap(Map<String, dynamic> user) {
    return user != null ? User(uid: user['uid'], type: user['type']) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      var userMap = new Map();
      userMap['uid'] = user.uid;
      userMap['type'] = "emailPassword";
      return _userFromMap(userMap);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithGoogle(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      var userMap = new Map();
      userMap['uid'] = user.uid;
      userMap['type'] = "google";
      return _userFromMap(userMap);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut(type) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      if (type == "google") {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
        await _auth.signOut();
      } else {
        await _auth.signOut();
      }

      return true;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
