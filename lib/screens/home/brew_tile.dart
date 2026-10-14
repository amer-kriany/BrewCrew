import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class BrewTile extends StatefulWidget {
  final Brew brew;
  final String? currentUserId;
  const BrewTile({super.key, required this.brew, required this.currentUserId});

  @override
  State<BrewTile> createState() => _BrewTileState();
}

class _BrewTileState extends State<BrewTile> {
  bool _pressed = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  bool get _isOwner =>
      widget.currentUserId != null &&
      widget.currentUserId!.isNotEmpty &&
      widget.currentUserId == widget.brew.uid;

  void _openDetails() {
    final title = _isOwner ? 'Edit your brew' : '${widget.brew.name}\'s brew';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        if (_isOwner) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              22,
              12,
              22,
              MediaQuery.of(sheetContext).viewInsets.bottom + 24,
            ),
            child: const SettingsForm(),
          );
        }
        return _ReadOnlyBrewSheet(title: title, brew: widget.brew);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brew = widget.brew;
    final strength = brew.strength.clamp(100, 900);
    final level = ((strength - 100) / 800).clamp(0.0, 1.0);
    final strengthLabel = strength < 350
        ? 'LIGHT ROAST'
        : strength < 650
            ? 'MEDIUM ROAST'
            : 'DARK ROAST';
    return Semantics(
      button: true,
      label: _isOwner
          ? 'Your coffee preferences. Double tap to edit.'
          : '${brew.name} coffee preferences. Double tap to view.',
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, .08),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) {
              setState(() => _pressed = false);
              _openDetails();
            },
            child: AnimatedScale(
              scale: _pressed ? .975 : 1,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF7),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _isOwner
                        ? ember.withOpacity(.5)
                        : const Color(0xFFEAE0D5),
                    width: _isOwner ? 1.3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF382719).withOpacity(.05),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(children: [
                  Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF3E4D4),
                          borderRadius: BorderRadius.circular(18)),
                      child: const Icon(Icons.coffee_rounded,
                          color: Color(0xFF8E4C2B), size: 27)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            brew.name.trim().isEmpty
                                ? 'Mystery brewer'
                                : brew.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color(0xFF171411),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.3)),
                        const SizedBox(height: 5),
                        Text(
                            '${brew.sugars == '0' ? 'No sugar' : '${brew.sugars} sugar'}  ·  ${brew.milk} milk  ·  $strengthLabel',
                            style: const TextStyle(
                                color: Color(0xFF8B8177),
                                fontSize: 10,
                                letterSpacing: .55,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 11),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                              value: level,
                              minHeight: 4,
                              backgroundColor: const Color(0xFFEFE5DB),
                              valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFE8753D))),
                        ),
                      ])),
                  const SizedBox(width: 12),
                  Column(children: [
                    Text('${(strength / 10).round()}%',
                        style: const TextStyle(
                            color: Color(0xFF171411),
                            fontSize: 15,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    const Text('STRENGTH',
                        style: TextStyle(
                            color: Color(0xFF8B8177),
                            fontSize: 8,
                            letterSpacing: .8,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Icon(
                        _isOwner
                            ? Icons.edit_outlined
                            : Icons.chevron_right_rounded,
                        size: 16,
                        color: _isOwner ? ember : muted),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyBrewSheet extends StatelessWidget {
  final String title;
  final Brew brew;
  const _ReadOnlyBrewSheet({required this.title, required this.brew});

  @override
  Widget build(BuildContext context) {
    final strength = brew.strength.clamp(100, 900);
    final strengthLabel = strength < 350
        ? 'Light & mellow'
        : strength < 650
            ? 'Balanced & smooth'
            : 'Bold & intense';
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
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
            const Text('CREW CUP',
                style: TextStyle(
                    color: ember,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            Text(title,
                style: const TextStyle(
                    color: espresso,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.8)),
            const SizedBox(height: 22),
            _PreferenceRow(
                icon: Icons.water_drop_outlined,
                label: 'Milk',
                value: brew.milk),
            _PreferenceRow(
                icon: Icons.auto_awesome_outlined,
                label: 'Sweetness',
                value: brew.sugars == '0'
                    ? 'No sugar'
                    : '${brew.sugars} ${brew.sugars == '1' ? 'spoon' : 'spoons'}'),
            _PreferenceRow(
                icon: Icons.local_fire_department_outlined,
                label: 'Intensity',
                value: '$strength% · $strengthLabel'),
            const SizedBox(height: 18),
            SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: espresso,
                        side: const BorderSide(color: Color(0xFFE2D6CA)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text('CLOSE',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, letterSpacing: 1)))),
          ]),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PreferenceRow(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
              color: const Color(0xFFF6F0E7),
              borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Icon(icon, color: ember, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700))),
            Text(value,
                style: const TextStyle(
                    color: espresso, fontSize: 13, fontWeight: FontWeight.w800))
          ]),
        ),
      );
}
