import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';
import 'package:flutter/material.dart';

class BrewList extends StatelessWidget {
  final List<Brew>? brews;
  final String? currentUserId;
  final bool isLoading;
  final Object? error;
  final VoidCallback? onAddCoffeeCard;

  const BrewList({
    super.key,
    required this.brews,
    required this.currentUserId,
    required this.isLoading,
    required this.error,
    required this.onAddCoffeeCard,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && brews == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFE8753D)),
        ),
      );
    }
    if (error != null) {
      return const _StatusCard(
        icon: Icons.cloud_off_rounded,
        title: 'The lineup is taking a moment',
        message:
            'We could not load the crew cards right now. Try again shortly.',
      );
    }

    final crew = brews ?? const <Brew>[];
    if (crew.isEmpty) {
      return const _StatusCard(
        icon: Icons.coffee_outlined,
        title: 'Your table is waiting',
        message: 'Your crew will show up here once their brews are ready.',
      );
    }

    final hasOwnCard =
        currentUserId != null && crew.any((brew) => brew.uid == currentUserId);
    final children = <Widget>[];
    if (!hasOwnCard && onAddCoffeeCard != null) {
      children.add(_AddCoffeeCard(onPressed: onAddCoffeeCard!));
    }
    children.addAll(
      crew.map(
        (brew) => BrewTile(brew: brew, currentUserId: currentUserId),
      ),
    );
    return Column(children: children);
  }
}

class _AddCoffeeCard extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddCoffeeCard({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add your coffee card',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3A2A20), Color(0xFF171411)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF382719).withOpacity(.12),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8753D).withOpacity(.18),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Color(0xFFFFB38E), size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ADD YOUR COFFEE CARD',
                            style: TextStyle(
                                color: Color(0xFFFFB38E),
                                fontSize: 10,
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.w900)),
                        SizedBox(height: 7),
                        Text(
                            'Let your crew know exactly how you like your coffee.',
                            style: TextStyle(
                                color: Color(0xFFFFFCF7),
                                fontSize: 14,
                                height: 1.35,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFFFFB38E), size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DED2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 34, color: const Color(0xFFE8753D)),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF171411))),
          const SizedBox(height: 5),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, height: 1.5, color: Color(0xFF8B8177))),
        ],
      ),
    );
  }
}
