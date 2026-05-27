import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../models/airport.dart';
import '../services/fids_service.dart';
import '../services/translations.dart';
import '../widgets/flight_card.dart';

class FlightsScreen extends StatefulWidget {
  final Airport airport;
  const FlightsScreen({super.key, required this.airport});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Flight>>? _flights;
  bool _loading = true;
  String? _error;
  final ScrollController _arrivalsScrollController = ScrollController();
  final ScrollController _departuresScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<_StatusDef> _statusDefs = [
    _StatusDef(key: 'Landed', persianMatch: 'نشست', icon: Icons.touch_app, color: Color(0xFF2E7D32)),
    _StatusDef(key: 'Delayed', persianMatch: 'تاخیر', icon: Icons.schedule, color: Color(0xFFC62828)),
    _StatusDef(key: 'Cancelled', persianMatch: 'لغو', icon: Icons.cancel, color: Color(0xFF424242)),
    _StatusDef(key: 'OnSchedule', persianMatch: 'طبق برنامه', icon: Icons.check_circle, color: Color(0xFF1565C0)),
    _StatusDef(key: 'CheckIn', persianMatch: 'پذیرش', icon: Icons.assignment_turned_in, color: Color(0xFFEF6C00)),
    _StatusDef(key: 'InProgress', persianMatch: 'در حال', icon: Icons.hourglass_top, color: Color(0xFFE65100)),
    _StatusDef(key: 'Departed', persianMatch: 'پروازکرد', icon: Icons.flight_takeoff, color: Color(0xFF1B5E20)),
  ];

  static const String _translationKeyPrefix = 'status';

  String _statusLabel(String key) {
    return TranslationService.instance.tr('$_translationKeyPrefix$key');
  }

  final Set<String> _selectedStatusKeys = {};

  List<Flight> _filteredFlights(List<Flight> flights) {
    var result = flights;

    if (_selectedStatusKeys.isNotEmpty) {
      result = result.where((f) =>
        _selectedStatusKeys.any((k) => f.status.contains(
          _statusDefs.firstWhere((d) => d.key == k).persianMatch,
        )),
      ).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((f) =>
        f.airline.toLowerCase().contains(q) ||
        f.flightNumber.toLowerCase().contains(q) ||
        f.origin.toLowerCase().contains(q),
      ).toList();
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    TranslationService.instance.addListener(_onLocaleChanged);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _scrollToAfterLastLanded();
      }
    });
    _searchController.addListener(() {
      setState(() { _searchQuery = _searchController.text; });
    });
    _loadFlights();
  }

  void _onLocaleChanged() => setState(() {});

  Future<void> _loadFlights() async {
    setState(() { _loading = true; _error = null; });
    try {
      final flights = await FidsService().fetchFlights(widget.airport);
      if (mounted) setState(() { _flights = flights; _loading = false; });
      _scrollToAfterLastLanded();
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _scrollToAfterLastLanded() {
    if (_flights == null || _searchQuery.isNotEmpty || _selectedStatusKeys.isNotEmpty) return;
    final flights = _tabController.index == 0
        ? _flights!['arrivals'] ?? []
        : _flights!['departures'] ?? [];
    if (flights.isEmpty) return;

    int lastLandedIndex = -1;
    for (int i = 0; i < flights.length; i++) {
      if (flights[i].status.contains('نشست')) {
        lastLandedIndex = i;
      }
    }

    final scrollToIndex = lastLandedIndex + 1;
    if (scrollToIndex >= flights.length) return;

    final controller = _tabController.index == 0
        ? _arrivalsScrollController
        : _departuresScrollController;

    const double itemHeight = 130;
    final targetOffset = scrollToIndex * itemHeight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;
      final maxScroll = controller.position.maxScrollExtent;
      controller.animateTo(
        targetOffset.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    TranslationService.instance.removeListener(_onLocaleChanged);
    _tabController.dispose();
    _arrivalsScrollController.dispose();
    _departuresScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = TranslationService.instance;
    return Directionality(
      textDirection: t.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.airport.name} - ${t.tr('flightInfo')}'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontSize: 13),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flight_land, size: 16),
                        const SizedBox(width: 6),
                        Text(t.tr('arrivals')),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flight_takeoff, size: 16),
                        const SizedBox(width: 6),
                        Text(t.tr('departures')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _buildBody(theme),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final t = TranslationService.instance;
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(t.tr('errorLoading'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadFlights,
              icon: const Icon(Icons.refresh),
              label: Text(t.tr('retry')),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: t.tr('searchHint'),
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade500),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            itemCount: _statusDefs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final f = _statusDefs[i];
              final label = _statusLabel(f.key);
              final selected = _selectedStatusKeys.contains(f.key);
              return FilterChip(
                label: Text(label,
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500)),
                selected: selected,
                selectedColor: f.color.withAlpha(25),
                checkmarkColor: f.color,
                avatar: Icon(f.icon,
                    size: 14, color: selected ? f.color : Colors.grey.shade500),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedStatusKeys.add(f.key);
                    } else {
                      _selectedStatusKeys.remove(f.key);
                    }
                  });
                },
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selected ? f.color.withAlpha(100) : Colors.grey.shade300,
                    width: selected ? 1.2 : 0.5,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFlightList(
                  _filteredFlights(_flights!['arrivals'] ?? []),
                  _arrivalsScrollController),
              _buildFlightList(
                  _filteredFlights(_flights!['departures'] ?? []),
                  _departuresScrollController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightList(List<Flight> flights, ScrollController controller) {
    final t = TranslationService.instance;
    if (flights.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty || _selectedStatusKeys.isNotEmpty
                  ? t.tr('noFlightsFound')
                  : t.tr('noFlightsAtAll'),
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFlights,
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: flights.length,
        itemBuilder: (_, i) => FlightCard(flight: flights[i]),
      ),
    );
  }
}

class _StatusDef {
  final String key;
  final String persianMatch;
  final IconData icon;
  final Color color;

  const _StatusDef({
    required this.key,
    required this.persianMatch,
    required this.icon,
    required this.color,
  });
}
