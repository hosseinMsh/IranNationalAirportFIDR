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

  @override
  void initState() {
    super.initState();
    TranslationService.instance.addListener(_onLocaleChanged);
    _tabController = TabController(length: 2, vsync: this);
    _loadFlights();
  }

  void _onLocaleChanged() => setState(() {});

  Future<void> _loadFlights() async {
    setState(() { _loading = true; _error = null; });
    try {
      final flights = await FidsService().fetchFlights(widget.airport);
      if (mounted) setState(() { _flights = flights; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  void dispose() {
    TranslationService.instance.removeListener(_onLocaleChanged);
    _tabController.dispose();
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
          bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(icon: const Icon(Icons.flight_land), text: t.tr('arrivals')),
              Tab(icon: const Icon(Icons.flight_takeoff), text: t.tr('departures')),
            ],
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

    return TabBarView(
      controller: _tabController,
      children: [
        _buildFlightList(_flights!['arrivals'] ?? []),
        _buildFlightList(_flights!['departures'] ?? []),
      ],
    );
  }

  Widget _buildFlightList(List<Flight> flights) {
    if (flights.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(t.tr('noFlightsAtAll'), style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: flights.length,
      itemBuilder: (_, i) => FlightCard(flight: flights[i]),
    );
  }

  TranslationService get t => TranslationService.instance;
}
