import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthService {

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  // create user obj based on firebase user
  User? _userFromFirebaseUser(fb.User? user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future<User?> signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      if (user == null) {
        return null;
      }
      await DatabaseService(uid: user.uid).ensureDefaultUserData();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) {
        return null;
      }
      await DatabaseService(uid: user.uid).ensureDefaultUserData();
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) {
        return null;
      }
      await DatabaseService(uid: user.uid).ensureDefaultUserData();
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

}
