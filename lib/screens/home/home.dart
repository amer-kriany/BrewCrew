import 'dart:async';

import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    void showSettingsPanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: paper,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.fromLTRB(
              22, 12, 22, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
          child: const SettingsForm(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: espresso,
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset('assets/brew_crew_logo.png',
                            fit: BoxFit.contain))),
                const SizedBox(width: 12),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('BREW CLUB',
                          style: TextStyle(
                              color: muted,
                              fontSize: 10,
                              letterSpacing: 2.4,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 3),
                      Text('Brew Crew',
                          style: TextStyle(
                              color: espresso,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.5))
                    ])),
                IconButton(
                    tooltip: 'Settings',
                    onPressed: showSettingsPanel,
                    style: IconButton.styleFrom(
                        backgroundColor: paper, foregroundColor: espresso),
                    icon: const Icon(Icons.tune_rounded)),
                const SizedBox(width: 6),
                IconButton(
                    tooltip: 'Sign out',
                    onPressed: () async => _auth.signOut(),
                    style: IconButton.styleFrom(
                        backgroundColor: paper, foregroundColor: espresso),
                    icon: const Icon(Icons.logout_rounded)),
              ]),
              const SizedBox(height: 28),
              const CoffeeCarousel(),
              const SizedBox(height: 30),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('THE LINEUP',
                          style: TextStyle(
                              color: ember,
                              fontSize: 10,
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w900)),
                      SizedBox(height: 7),
                      Text('Meet the crew',
                          style: TextStyle(
                              color: espresso,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.8))
                    ])),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0xFFECE1D4),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text('LIVE BREWS  •',
                        style: TextStyle(
                            color: roast,
                            fontSize: 9,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800)))
              ]),
              const SizedBox(height: 16),
              StreamBuilder<List<Brew>>(
                  stream: user == null
                      ? const Stream<List<Brew>>.empty()
                      : DatabaseService(uid: user.uid).brews,
                  builder: (context, snapshot) => BrewList(
                      brews: snapshot.data,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                      error: snapshot.hasError ? snapshot.error : null,
                      currentUserId: user?.uid,
                      onAddCoffeeCard: showSettingsPanel)),
              const SizedBox(height: 18),
              Center(
                  child: Text('MADE FOR SLOW MORNINGS  ·  BREWED TOGETHER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: muted,
                          fontSize: 9,
                          letterSpacing: 1.25,
                          fontWeight: FontWeight.w700))),
            ])),
          ),
        ]),
      ),
    );
  }
}

class CoffeeCarousel extends StatefulWidget {
  const CoffeeCarousel({super.key});
  @override
  State<CoffeeCarousel> createState() => _CoffeeCarouselState();
}

class _CoffeeCarouselState extends State<CoffeeCarousel>
    with WidgetsBindingObserver {
  final PageController _controller = PageController(viewportFraction: .94);
  Timer? _autoAdvanceTimer;
  int _page = 0;
  bool _isInteracting = false;
  final List<_CoffeeSlide> _slides = const [
    _CoffeeSlide(
        '01  /  THE DAILY RITUAL',
        'Good coffee.\nBetter company.',
        'A little ritual, shared well.',
        Icons.coffee_rounded,
        Color(0xFFE8753D)),
    _CoffeeSlide(
        '02  /  FIND YOUR BREW',
        'A little bold.\nA little you.',
        'Dial in sweetness, milk and strength.',
        Icons.water_drop_rounded,
        Color(0xFFD3A06C)),
    _CoffeeSlide(
        '03  /  YOUR CREW, YOUR COFFEE',
        'Every cup\nhas a story.',
        'See what makes your crew tick.',
        Icons.groups_rounded,
        Color(0xFFB3C08A)),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      _advanceIfIdle();
    });
  }

  void _pauseAutoAdvance() {
    _isInteracting = true;
  }

  void _resumeAutoAdvance() {
    _isInteracting = false;
  }

  void _advanceIfIdle() {
    if (!mounted ||
        _isInteracting ||
        !_controller.hasClients ||
        MediaQuery.maybeOf(context)?.disableAnimations == true) {
      return;
    }
    final nextPage = (_page + 1) % _slides.length;
    _controller.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumeAutoAdvance();
    } else {
      _pauseAutoAdvance();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoAdvanceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Semantics(
          label:
              'Brew Crew stories carousel. Slide ${_page + 1} of ${_slides.length}. Swipe horizontally to explore.',
          child: SizedBox(
              height: 238,
              child: Listener(
                  onPointerDown: (_) => _pauseAutoAdvance(),
                  onPointerUp: (_) => _resumeAutoAdvance(),
                  onPointerCancel: (_) => _resumeAutoAdvance(),
                  child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _controller,
                      itemCount: _slides.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final currentPage = _controller.hasClients
                                  ? (_controller.page ?? _page.toDouble())
                                  : _page.toDouble();
                              final distance =
                                  (currentPage - index).abs().clamp(0.0, 1.0);
                              final scale = 1 - (distance * .018);
                              final verticalInset = distance * 7;
                              return Transform.scale(
                                scale: scale,
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOutCubic,
                                    margin: EdgeInsets.only(
                                        right: 8,
                                        top: verticalInset,
                                        bottom: verticalInset),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: index == 1
                                                ? const [
                                                    Color(0xFF533522),
                                                    Color(0xFF171411)
                                                  ]
                                                : index == 2
                                                    ? const [
                                                        Color(0xFF3A4432),
                                                        Color(0xFF171411)
                                                      ]
                                                    : const [
                                                        Color(0xFF30251D),
                                                        Color(0xFF171411)
                                                      ]),
                                        borderRadius:
                                            BorderRadius.circular(28)),
                                    child: Stack(children: [
                                      Positioned.fill(
                                          child: CustomPaint(
                                              painter: _CoffeeArtworkPainter(
                                                  index: index,
                                                  accent: slide.accent))),
                                      Positioned(
                                          right: 22,
                                          top: 24,
                                          child: Icon(slide.icon,
                                              size: 30,
                                              color: slide.accent
                                                  .withOpacity(.92))),
                                      Positioned(
                                          right: 12,
                                          bottom: 24,
                                          child: Text('BREW\\nTOGETHER',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(.22),
                                                  fontSize: 9,
                                                  height: 1.1,
                                                  letterSpacing: 1.5,
                                                  fontWeight:
                                                      FontWeight.w900))),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(slide.eyebrow,
                                                style: TextStyle(
                                                    color: slide.accent,
                                                    fontSize: 9,
                                                    letterSpacing: 1.5,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            const SizedBox(height: 20),
                                            Text(slide.title,
                                                style: const TextStyle(
                                                    color: Color(0xFFFFFCF7),
                                                    fontSize: 30,
                                                    height: 1.08,
                                                    fontWeight: FontWeight.w900,
                                                    letterSpacing: -1.1)),
                                            const SizedBox(height: 10),
                                            Text(slide.subtitle,
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFFFFFCF7)
                                                            .withOpacity(.68),
                                                    fontSize: 12,
                                                    height: 1.4)),
                                            const Spacer(),
                                            Row(
                                                children: List.generate(
                                                    _slides.length,
                                                    (i) => AnimatedContainer(
                                                        duration: const Duration(
                                                            milliseconds: 250),
                                                        margin:
                                                            const EdgeInsets.only(
                                                                right: 6),
                                                        width:
                                                            i == _page ? 25 : 7,
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                            color: i == _page
                                                                ? const Color(
                                                                    0xFFE8753D)
                                                                : Colors.white
                                                                    .withOpacity(
                                                                        .25),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))))),
                                          ]),
                                    ])),
                              );
                            });
                      }))),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.swipe_rounded, size: 13, color: Color(0xFF8B8177)),
          const SizedBox(width: 5),
          Text('SWIPE TO EXPLORE  ·  ${_page + 1} / ${_slides.length}',
              style: const TextStyle(
                  color: Color(0xFF8B8177),
                  fontSize: 9,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800))
        ]),
      ]);
}

class _CoffeeSlide {
  final String eyebrow, title, subtitle;
  final IconData icon;
  final Color accent;
  const _CoffeeSlide(
      this.eyebrow, this.title, this.subtitle, this.icon, this.accent);
}

class _CoffeeArtworkPainter extends CustomPainter {
  final int index;
  final Color accent;
  const _CoffeeArtworkPainter({required this.index, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width * .83, size.height * .47);
    paint.color = accent.withOpacity(.18);
    canvas.drawCircle(center, size.height * .42, paint);
    paint.color = Colors.white.withOpacity(.06);
    canvas.drawCircle(
        Offset(size.width * .98, size.height * .02), size.height * .25, paint);
    paint.color = accent.withOpacity(.28);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * .77, size.height * .57),
            width: 78,
            height: 36),
        paint);
    paint.color = Colors.white.withOpacity(.1);
    for (var i = 0; i < 5; i++) {
      final x = size.width * (.63 + i * .075);
      final y = size.height * (.22 + (i.isEven ? .06 : .18));
      canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: 10, height: 17), paint);
    }
    if (index == 1) {
      paint.color = accent.withOpacity(.22);
      canvas.drawCircle(Offset(size.width * .69, size.height * .77), 24, paint);
      canvas.drawCircle(Offset(size.width * .91, size.height * .72), 13, paint);
    } else if (index == 2) {
      paint.color = accent.withOpacity(.3);
      canvas.drawCircle(Offset(size.width * .78, size.height * .37), 31, paint);
      canvas.drawCircle(Offset(size.width * .9, size.height * .55), 18, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CoffeeArtworkPainter oldDelegate) =>
      oldDelegate.index != index || oldDelegate.accent != accent;
}
