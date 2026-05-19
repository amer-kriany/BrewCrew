import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  int _safeStrength(dynamic value) {
    if (value is int && value >= 100 && value <= 900) {
      return value;
    }
    return 100;
  }

  String _safeSugars(dynamic value) {
    if (value is String && {'0', '1', '2', '3', '4'}.contains(value)) {
      return value;
    }
    return '0';
  }

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid!).set({
      'sugars': _safeSugars(sugars),
      'name': name,
      'strength': _safeStrength(strength),
    });
  }

  Future<void> ensureDefaultUserData() async {
    final docRef = brewCollection.doc(uid!);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      await docRef.set({
        'sugars': '0',
        'name': 'new crew member',
        'strength': 100,
      });
    }
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Brew(
          name: data['name'] ?? 'new crew member',
          strength: _safeStrength(data['strength']),
          sugars: _safeSugars(data['sugars']));
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return UserData(
        uid: uid!,
        name: data['name'] ?? 'new crew member',
        sugars: _safeSugars(data['sugars']),
        strength: _safeStrength(data['strength']));
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
