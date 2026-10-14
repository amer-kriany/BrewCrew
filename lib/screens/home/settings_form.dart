import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});
  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  String? _currentName, _currentSugars, _currentMilk;
  final List<String> milks = ['Black', 'A splash', 'Regular', 'Extra creamy'];
  int? _currentStrength;
  bool _saving = false;
  int _normalizeStrength(int? strength) =>
      (strength == null || strength < 100 || strength > 900)
          ? 100
          : ((strength / 100).round() * 100).clamp(100, 900);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return const SizedBox.shrink();
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Could not load your brew settings.'));
          if (!snapshot.hasData)
            return const Padding(padding: EdgeInsets.all(24), child: Loading());
          final userData = snapshot.data!;
          final selectedStrength =
              _normalizeStrength(_currentStrength ?? userData.strength);
          final selectedSugars =
              sugars.contains(_currentSugars ?? userData.sugars)
                  ? (_currentSugars ?? userData.sugars)
                  : '0';
          final selectedMilk = milks.contains(_currentMilk ?? userData.milk)
              ? (_currentMilk ?? userData.milk)
              : 'Regular';
          final strengthName = selectedStrength < 350
              ? 'Light & mellow'
              : selectedStrength < 650
                  ? 'Balanced & smooth'
                  : 'Bold & intense';
          return SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Container(
                                width: 42,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE2D6CA),
                                    borderRadius: BorderRadius.circular(8)))),
                        const SizedBox(height: 25),
                        const Text('MAKE IT YOURS',
                            style: TextStyle(
                                color: Color(0xFFE8753D),
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 7),
                        const Text('Your perfect cup.',
                            style: TextStyle(
                                color: Color(0xFF171411),
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.8)),
                        const SizedBox(height: 6),
                        const Text(
                            'Fine-tune your profile. We’ll remember the details.',
                            style: TextStyle(
                                color: Color(0xFF8B8177), fontSize: 12)),
                        const SizedBox(height: 25),
                        TextFormField(
                            initialValue: userData.name == 'new crew member'
                                ? ''
                                : userData.name,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Name on your cup'),
                            validator: (val) => val!.trim().isEmpty
                                ? 'Please enter a name'
                                : null,
                            onChanged: (val) =>
                                setState(() => _currentName = val)),
                        const SizedBox(height: 22),
                        const Text('SWEETNESS',
                            style: TextStyle(
                                color: Color(0xFF5F554B),
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 9),
                        DropdownButtonFormField<String>(
                            value: selectedSugars,
                            decoration: textInputDecoration,
                            items: sugars
                                .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s == '0'
                                        ? 'No sugar'
                                        : '$s ${s == '1' ? 'spoon' : 'spoons'} of sugar')))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _currentSugars = val)),
                        const SizedBox(height: 22),
                        const Text('MILK PREFERENCE',
                            style: TextStyle(
                                color: Color(0xFF5F554B),
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 9),
                        DropdownButtonFormField<String>(
                            value: selectedMilk,
                            decoration: textInputDecoration.copyWith(
                                prefixIcon: const Icon(
                                    Icons.water_drop_outlined,
                                    color: Color(0xFFE8753D))),
                            items: milks
                                .map((milk) => DropdownMenuItem(
                                    value: milk,
                                    child: Text({
                                      'Black': 'Black — no milk',
                                      'A splash': 'A splash',
                                      'Regular': 'Regular & balanced',
                                      'Extra creamy': 'Extra creamy'
                                    }[milk]!)))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _currentMilk = val)),
                        const SizedBox(height: 22),
                        Row(children: [
                          const Expanded(
                              child: Text('BREW INTENSITY',
                                  style: TextStyle(
                                      color: Color(0xFF5F554B),
                                      fontSize: 10,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w800))),
                          Text('$selectedStrength%',
                              style: const TextStyle(
                                  color: Color(0xFFE8753D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900))
                        ]),
                        Slider(
                            value: selectedStrength.toDouble(),
                            activeColor: const Color(0xFFE8753D),
                            inactiveColor: const Color(0xFFE9DDD0),
                            min: 100,
                            max: 900,
                            divisions: 8,
                            label: '$selectedStrength%',
                            onChanged: (v) =>
                                setState(() => _currentStrength = v.round())),
                        Row(children: [
                          const Icon(Icons.coffee_outlined,
                              color: Color(0xFF8B8177), size: 18),
                          const SizedBox(width: 8),
                          Text(strengthName,
                              style: const TextStyle(
                                  color: Color(0xFF8B8177),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600))
                        ]),
                        const SizedBox(height: 26),
                        Row(children: [
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: OutlinedButton(
                                onPressed: _saving
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF171411),
                                  side: const BorderSide(
                                      color: Color(0xFFE2D6CA)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: const Text('CANCEL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF171411),
                                    foregroundColor: const Color(0xFFFFFCF7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                                icon: _saving
                                    ? const SizedBox(
                                        width: 17,
                                        height: 17,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : const Icon(Icons.check_rounded),
                                label: Text(
                                    _saving ? 'SAVING...' : 'SAVE MY BREW',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1)),
                                onPressed: () async {
                                  if (_saving ||
                                      !_formKey.currentState!.validate())
                                    return;
                                  setState(() => _saving = true);
                                  final navigator = Navigator.of(context);
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  try {
                                    await DatabaseService(uid: user.uid)
                                        .updateUserData(
                                            selectedSugars,
                                            _currentName?.trim() ??
                                                userData.name,
                                            selectedStrength,
                                            selectedMilk);
                                    if (!mounted) return;
                                    navigator.pop();
                                    messenger.showSnackBar(const SnackBar(
                                        content: Text(
                                            'Your brew profile is updated.')));
                                  } on FirebaseException catch (error) {
                                    debugPrint(
                                        'Failed to update brew settings: ${error.message}');
                                    if (mounted) {
                                      setState(() => _saving = false);
                                      messenger.showSnackBar(const SnackBar(
                                          content: Text(
                                              'Could not save your brew settings.')));
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 10),
                      ])));
        });
  }
}
