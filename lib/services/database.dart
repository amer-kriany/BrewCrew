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

  String _safeMilk(dynamic value) =>
      {'Black', 'A splash', 'Regular', 'Extra creamy'}.contains(value)
          ? value as String
          : 'Regular';

  Future<void> updateUserData(String sugars, String name, int strength,
      [String milk = 'Regular']) async {
    return await brewCollection.doc(uid!).set({
      'sugars': _safeSugars(sugars),
      'name': name,
      'strength': _safeStrength(strength),
      'milk': _safeMilk(milk),
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
        'milk': 'Regular',
      });
    }
  }

  Brew _brewFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return Brew(
      uid: snapshot.id,
      name: data['name'] ?? 'new crew member',
      strength: _safeStrength(data['strength']),
      sugars: _safeSugars(data['sugars']),
      milk: _safeMilk(data['milk']),
    );
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return UserData(
        uid: uid!,
        name: data['name'] ?? 'new crew member',
        sugars: _safeSugars(data['sugars']),
        strength: _safeStrength(data['strength']),
        milk: _safeMilk(data['milk']));
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    if (uid == null) {
      return Stream.value(const <Brew>[]);
    }

    return brewCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_brewFromSnapshot).toList());
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
