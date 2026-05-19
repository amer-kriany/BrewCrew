class User {
  final String uid;

  const User({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  const UserData({
    required this.uid,
    required this.sugars,
    required this.strength,
    required this.name,
  });
}
