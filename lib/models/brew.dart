class Brew {
  final String uid;
  final String name;
  final String sugars;
  final int strength;
  final String milk;

  const Brew(
      {required this.uid,
      required this.name,
      required this.sugars,
      required this.strength,
      this.milk = 'Regular'});
}
