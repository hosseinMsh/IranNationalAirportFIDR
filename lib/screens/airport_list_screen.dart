import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/airport.dart';
import '../services/fids_service.dart';
import '../services/translations.dart';
import '../services/myket_service.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _pinnedAirportIds = {'2', '102'}; // مهرآباد و مشهد به‌صورت پیش‌فرض
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _togglePin(String id) {
    setState(() {
      if (_pinnedAirportIds.contains(id)) {
        _pinnedAirportIds.remove(id);
      } else {
        _pinnedAirportIds.add(id);
      }
    });
  }

  List<Airport> _filterList(List<Airport> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.nameEn.toLowerCase().contains(q) ||
          a.iataCode.toLowerCase().contains(q);
    }).toList();
  }

  void _showAboutSheet(BuildContext context) {
    final t = TranslationService.instance;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.flight_takeoff,
                        color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.tr('appTitle'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${t.tr('version')} 1.1.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withAlpha(120),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.tr('disclaimer'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.tr('disclaimerText'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => MyketService.rateApp(),
                      icon: const Icon(Icons.star_rate_rounded, size: 18),
                      label: Text(t.tr('rateInMyket')),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => MyketService.checkUpdate(),
                      icon: const Icon(Icons.system_update_rounded, size: 18),
                      label: Text(t.tr('checkUpdate')),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.instance;
    final allAirports = FidsService.airports;
    final filteredAirports = _filterList(allAirports);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.tr('pressBackAgainToExit')),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.tr('airportsTitle')),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: t.tr('aboutApp'),
              onPressed: () => _showAboutSheet(context),
            ),
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
                  value: 'en',
                  child: Row(
                    children: [
                      if (t.langCode == 'en') const Icon(Icons.check, size: 18),
                      SizedBox(width: t.langCode == 'en' ? 8 : 26),
                      const Text('English'),
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
              ],
            ),
          ],
        ),
        body: Container(
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
          child: Column(
            children: [
              // نوار جستجو
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(6),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: t.tr('searchAirports'),
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, size: 22),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              // محتوای فرودگاه‌ها
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _buildSearchResults(filteredAirports)
                    : _buildGroupedList(allAirports),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Airport> airports) {
    final t = TranslationService.instance;
    if (airports.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              t.tr('noAirportsFound'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
      itemCount: airports.length,
      itemBuilder: (context, index) {
        final airport = airports[index];
        final isPinned = _pinnedAirportIds.contains(airport.id);
        return _AirportCard(
          airport: airport,
          index: index,
          isPinned: isPinned,
          onPinToggle: () => _togglePin(airport.id),
          onTap: () => _navigateToFlights(airport),
          onNavigate: () => _navigateToMap(airport),
        );
      },
    );
  }

  Widget _buildGroupedList(List<Airport> all) {
    final t = TranslationService.instance;
    final pinned = all.where((a) => _pinnedAirportIds.contains(a.id)).toList();
    final others = all.where((a) => !_pinnedAirportIds.contains(a.id)).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
      children: [
        if (pinned.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                const Icon(Icons.push_pin, size: 16, color: Color(0xFFFF8F00)),
                const SizedBox(width: 6),
                Text(
                  t.tr('pinnedAirports'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),
          ...pinned.asMap().entries.map((e) {
            return _AirportCard(
              airport: e.value,
              index: e.key,
              isPinned: true,
              onPinToggle: () => _togglePin(e.value.id),
              onTap: () => _navigateToFlights(e.value),
              onNavigate: () => _navigateToMap(e.value),
            );
          }),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              t.tr('allAirports'),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
        ...others.asMap().entries.map((e) {
          return _AirportCard(
            airport: e.value,
            index: e.key + pinned.length,
            isPinned: false,
            onPinToggle: () => _togglePin(e.value.id),
            onTap: () => _navigateToFlights(e.value),
            onNavigate: () => _navigateToMap(e.value),
          );
        }),
      ],
    );
  }

  void _navigateToFlights(Airport airport) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FlightsScreen(airport: airport),
        transitionsBuilder: (_, a, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: a, child: child),
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToMap(Airport airport) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AirportMapScreen(airport: airport),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}

class _AirportCard extends StatelessWidget {
  final Airport airport;
  final int index;
  final bool isPinned;
  final VoidCallback onPinToggle;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const _AirportCard({
    required this.airport,
    required this.index,
    required this.isPinned,
    required this.onPinToggle,
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
    final isEn = TranslationService.instance.langCode == 'en';
    final displayName = isEn ? airport.nameEn : airport.name;
    final secondaryName = isEn ? airport.name : airport.nameEn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPinned ? const Color(0xFFFFB300) : Colors.grey.shade200,
              width: isPinned ? 1.2 : 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: isPinned
                    ? const Color(0xFFFF8F00).withAlpha(20)
                    : accentColor.withAlpha(12),
                blurRadius: 10,
                offset: const Offset(0, 3),
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
                      colors: isPinned
                          ? [
                              const Color(0xFFFF8F00),
                              const Color(0xFFFFB300),
                            ]
                          : [
                              accentColor.withAlpha(200),
                              accentColor.withAlpha(90),
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
                        horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentColor.withAlpha(25),
                                accentColor.withAlpha(10),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.flight_takeoff_rounded,
                            color: accentColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (airport.iataCode.isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: accentColor.withAlpha(15),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: accentColor.withAlpha(40),
                                          width: 0.6,
                                        ),
                                      ),
                                      child: Text(
                                        airport.iataCode,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: accentColor,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                secondaryName,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // دکمه پین / برگزیده
                        IconButton(
                          icon: Icon(
                            isPinned
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            size: 20,
                            color: isPinned
                                ? const Color(0xFFFF8F00)
                                : Colors.grey.shade400,
                          ),
                          tooltip: isPinned
                              ? TranslationService.instance.tr('unpinAirport')
                              : TranslationService.instance.tr('pinAirport'),
                          onPressed: onPinToggle,
                        ),
                        // دکمه مسیریابی
                        IconButton(
                          icon: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: accentColor.withAlpha(15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.directions_outlined,
                              color: accentColor,
                              size: 18,
                            ),
                          ),
                          tooltip: TranslationService.instance.tr('navigateToAirport'),
                          onPressed: onNavigate,
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
    );
  }
}
