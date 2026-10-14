import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a crew member card', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const BrewTile(
            currentUserId: 'test-user',
            brew: Brew(
                uid: 'test-user',
                name: 'new crew member',
                sugars: '0',
                strength: 100),
          ),
        ),
      ),
    );

    expect(find.text('new crew member'), findsOneWidget);
    expect(find.textContaining('No sugar'), findsOneWidget);
  });

  testWidgets('opens a friend brew as read only', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BrewTile(
            currentUserId: 'current-user',
            brew: const Brew(
              uid: 'friend-user',
              name: 'Maya',
              sugars: '2',
              strength: 700,
              milk: 'A splash',
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Maya'));
    await tester.pumpAndSettle();

    expect(find.text('Maya\'s brew'), findsOneWidget);
    expect(find.text('CREW CUP'), findsOneWidget);
    expect(find.text('SAVE MY BREW'), findsNothing);
    expect(find.text('CANCEL'), findsNothing);
  });

  testWidgets('shows add-card CTA when only friends have cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BrewList(
            brews: const [
              Brew(
                uid: 'friend-user',
                name: 'Maya',
                sugars: '2',
                strength: 700,
              ),
            ],
            currentUserId: 'current-user',
            isLoading: false,
            error: null,
            onAddCoffeeCard: _noop,
          ),
        ),
      ),
    );

    expect(find.text('ADD YOUR COFFEE CARD'), findsOneWidget);
    expect(find.text('Let your crew know exactly how you like your coffee.'),
        findsOneWidget);
    expect(find.text('Maya'), findsOneWidget);
  });
}

void _noop() {}
