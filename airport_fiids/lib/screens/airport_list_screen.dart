import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import '../services/fids_service.dart';
import '../services/translations.dart';
import '../widgets/ad_banner.dart';
import 'flights_screen.dart';
import 'airport_map_screen.dart';

class AirportListScreen extends StatefulWidget {
  const AirportListScreen({super.key});

  @override
  State<AirportListScreen> createState() => _AirportListScreenState();
}

class _AirportListScreenState extends State<AirportListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.instance;
    return Directionality(
      textDirection: t.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.tr('airportsTitle')),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: (code) => t.setLangCode(code),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'fa',
                  child: Row(
                    children: [
                      if (t.langCode == 'fa') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'fa' ? 8 : 26),
                      const Text('فارسی'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'ar',
                  child: Row(
                    children: [
                      if (t.langCode == 'ar') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'ar' ? 8 : 26),
                      const Text('العربية'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      if (t.langCode == 'en') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'en' ? 8 : 26),
                      const Text('English'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withAlpha(10),
                Colors.black.withAlpha(15),
              ],
              stops: const [0.0, 0.88, 0.95, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade50,
                  Colors.grey.shade100,
                ],
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
              itemCount: FidsService.airports.length + 1,
              itemBuilder: (context, index) {
                if (index == FidsService.airports.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: AdBanner(placementId: AdService.bannerPlacementId),
                  );
                }
                final airport = FidsService.airports[index];
                final delay = Duration(milliseconds: 80 * index);
                return _AirportCard(
                  airport: airport,
                  index: index,
                  delay: delay,
                  animController: _animController,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            FlightsScreen(airport: airport),
                        transitionsBuilder: (_, a, __, child) =>
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.08),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: a,
                                curve: Curves.easeOutCubic,
                              )),
                              child: FadeTransition(opacity: a, child: child),
                            ),
                        transitionDuration:
                            const Duration(milliseconds: 350),
                      ),
                    );
                  },
                  onNavigate: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            AirportMapScreen(airport: airport),
                        transitionsBuilder: (_, a, __, child) =>
                            FadeTransition(opacity: a, child: child),
                        transitionDuration:
                            const Duration(milliseconds: 300),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AirportCard extends StatelessWidget {
  final dynamic airport;
  final int index;
  final Duration delay;
  final AnimationController animController;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const _AirportCard({
    required this.airport,
    required this.index,
    required this.delay,
    required this.animController,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF0D47A1),
      const Color(0xFF1565C0),
      const Color(0xFF1976D2),
      const Color(0xFF1E88E5),
      const Color(0xFF2196F3),
    ];
    final accentColor = colors[index % colors.length];

    return AnimatedBuilder(
      animation: animController,
      builder: (_, __) {
        final animValue = CurvedAnimation(
          parent: animController,
          curve: Interval(
            delay.inMilliseconds / 800,
            (delay.inMilliseconds + 200) / 800,
            curve: Curves.easeOutCubic,
          ),
        ).value;
        final slideOffset = Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).transform(animValue);
        final opacity = animValue;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: slideOffset * 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withAlpha(18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                accentColor.withAlpha(180),
                                accentColor.withAlpha(100),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        accentColor.withAlpha(30),
                                        accentColor.withAlpha(15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.flight_takeoff,
                                    color: accentColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        airport.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        airport.nameEn,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: accentColor.withAlpha(15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.directions_outlined,
                                      color: accentColor,
                                      size: 19,
                                    ),
                                  ),
                                  tooltip: 'مسیریابی',
                                  onPressed: onNavigate,
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_left,
                                  color: Colors.grey.shade400,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


