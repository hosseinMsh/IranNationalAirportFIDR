import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/live_flight.dart';
import '../services/live_radar_service.dart';
import '../services/translations.dart';

class LiveRadarScreen extends StatefulWidget {
  const LiveRadarScreen({super.key});

  @override
  State<LiveRadarScreen> createState() => _LiveRadarScreenState();
}

class _LiveRadarScreenState extends State<LiveRadarScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  List<LiveFlight> _flights = [];
  bool _loading = true;
  bool _refreshing = false;
  Timer? _pollingTimer;
  LiveFlight? _selectedFlight;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isDarkMap = false;

  late AnimationController _pulseController;

  static const LatLng _iranCenter = LatLng(32.4279, 53.6880);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    _loadFlights(initial: true);

    // به‌روزرسانی خودکار هر ۷ ثانیه یک‌بار
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (mounted) {
        _loadFlights(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFlights({bool initial = false, bool silent = false}) async {
    if (!silent) {
      setState(() {
        if (initial) {
          _loading = true;
        } else {
          _refreshing = true;
        }
      });
    }

    final list = await LiveRadarService.fetchLiveFlights();

    if (mounted) {
      setState(() {
        _flights = list;
        _loading = false;
        _refreshing = false;
        // بروزرسانی پرواز انتخاب‌شده در صورت وجود
        if (_selectedFlight != null) {
          final updated = _flights.where((f) => f.id == _selectedFlight!.id).firstOrNull;
          if (updated != null) {
            _selectedFlight = updated;
          }
        }
      });
    }
  }

  List<LiveFlight> get _filteredFlights {
    if (_searchQuery.isEmpty) return _flights;
    return _flights.where((f) {
      return f.displayFlightNumber.toLowerCase().contains(_searchQuery) ||
          f.callsign.toLowerCase().contains(_searchQuery) ||
          f.registration.toLowerCase().contains(_searchQuery) ||
          f.aircraftType.toLowerCase().contains(_searchQuery) ||
          f.originIata.toLowerCase().contains(_searchQuery) ||
          f.destIata.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Color _getFlightColor(LiveFlight flight) {
    if (flight.onGround) return Colors.grey.shade600;
    if (flight.altitude > 30000) return const Color(0xFF1E88E5); // آبی پرواز کروز
    if (flight.altitude > 18000) return const Color(0xFF00ACC1); // فیروزه‌ای
    if (flight.altitude > 8000) return const Color(0xFF43A047); // سبز
    return const Color(0xFFFB8C00); // نارنجی صعود / فرود ارتفاع پایین
  }

  void _showFlightDetails(LiveFlight flight) {
    setState(() => _selectedFlight = flight);
    final theme = Theme.of(context);
    final t = TranslationService.instance;

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
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header: شماره پرواز و مسیر
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getFlightColor(flight).withAlpha(25),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Transform.rotate(
                      angle: flight.heading * (math.pi / 180),
                      child: Icon(
                        Icons.flight_rounded,
                        color: _getFlightColor(flight),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              flight.displayFlightNumber,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (flight.aircraftType.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  flight.aircraftType,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          flight.routeDisplay.isNotEmpty
                              ? flight.routeDisplay
                              : (flight.callsign.isNotEmpty
                                  ? flight.callsign
                                  : 'موقعیت زنده پرواز'),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (flight.onGround)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        t.tr('onGround'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 18),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 16),

              // شبکه اطلاعات پرواز: ارتفاع، سرعت، جهت، شماره ثبت
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.3,
                children: [
                  _infoCard(
                    icon: Icons.height_rounded,
                    label: t.tr('flightAltitude'),
                    value: flight.onGround
                        ? t.tr('onGround')
                        : '${flight.altitude.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} ft',
                    sub: flight.onGround
                        ? ''
                        : '~${flight.altitudeMeters.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} m',
                    color: Colors.blue.shade700,
                  ),
                  _infoCard(
                    icon: Icons.speed_rounded,
                    label: t.tr('flightSpeed'),
                    value: '${flight.speed} kts',
                    sub: '~${flight.speedKmh} km/h',
                    color: Colors.teal.shade700,
                  ),
                  _infoCard(
                    icon: Icons.explore_rounded,
                    label: t.tr('flightHeading'),
                    value: '${flight.heading.round()}°',
                    sub: _headingCompass(flight.heading),
                    color: Colors.deepPurple.shade600,
                  ),
                  _infoCard(
                    icon: Icons.airplanemode_active_rounded,
                    label: t.tr('registration'),
                    value: flight.registration.isNotEmpty
                        ? flight.registration
                        : (flight.callsign.isNotEmpty ? flight.callsign : '-'),
                    sub: flight.category.isNotEmpty ? flight.category : 'Commercial',
                    color: Colors.indigo.shade600,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // فوتر: منبع آسمان‌جو و دکمه باز کردن در وب
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.tr('radarDataSource'),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse('https://asemanjoo.ir/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: const Text(
                      'مشاهده در آسمان‌جو',
                      style: TextStyle(fontSize: 11),
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

  String _headingCompass(double deg) {
    if (deg >= 337.5 || deg < 22.5) return 'شمال (N)';
    if (deg >= 22.5 && deg < 67.5) return 'شمال‌شرق (NE)';
    if (deg >= 67.5 && deg < 112.5) return 'شرق (E)';
    if (deg >= 112.5 && deg < 157.5) return 'جنوب‌شرق (SE)';
    if (deg >= 157.5 && deg < 202.5) return 'جنوب (S)';
    if (deg >= 202.5 && deg < 247.5) return 'جنوب‌غرب (SW)';
    if (deg >= 247.5 && deg < 292.5) return 'غرب (W)';
    return 'شمال‌غرب (NW)';
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _recenterToIran() {
    _mapController.move(_iranCenter, 5.5);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = TranslationService.instance;
    final flights = _filteredFlights;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr('liveRadar')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            tooltip: t.tr('refresh'),
            onPressed: () => _loadFlights(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // نقشه اصلی پروازها
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _iranCenter,
              initialZoom: 5.5,
              minZoom: 4,
              maxZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: _isDarkMap
                    ? 'https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'ir.shraif.airport_fiids',
              ),

              // لایه نشانگرهای هواپیماها
              MarkerLayer(
                markers: flights.map((flight) {
                  final isSelected = _selectedFlight?.id == flight.id;
                  final flightColor = _getFlightColor(flight);

                  return Marker(
                    point: LatLng(flight.lat, flight.lon),
                    width: isSelected ? 48 : 36,
                    height: isSelected ? 48 : 36,
                    child: GestureDetector(
                      onTap: () => _showFlightDetails(flight),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelected)
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: flightColor.withAlpha(50),
                                border: Border.all(color: flightColor, width: 2),
                              ),
                            ),
                          Transform.rotate(
                            angle: flight.heading * (math.pi / 180),
                            child: Icon(
                              Icons.flight_rounded,
                              size: isSelected ? 28 : 22,
                              color: flightColor,
                              shadows: const [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // پنل بالایی: تعداد زنده پروازها و نوار جستجو
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: Column(
              children: [
                // چیپ تعداد زنده پروازها
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(240),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (_, __) {
                          return Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00E676),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00E676)
                                      .withAlpha((_pulseController.value * 200).toInt()),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _loading
                            ? 'در حال دریافت رادار...'
                            : '${_flights.length} ${t.tr('flightsInIranAirspace')}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${flights.length} فیلترشده)',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // نوار جستجو پرواز
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: t.tr('searchFlightNumber'),
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // کنترل‌های شناور نقشه (سمت راست/پایین)
          Positioned(
            bottom: 24,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _mapActionButton(
                  icon: _isDarkMap ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  tooltip: 'تغییر لایه نقشه',
                  onTap: () {
                    setState(() => _isDarkMap = !_isDarkMap);
                  },
                ),
                const SizedBox(height: 8),
                _mapActionButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'مرکزیت ایران',
                  onTap: _recenterToIran,
                ),
                const SizedBox(height: 8),
                _mapActionButton(
                  icon: Icons.add,
                  tooltip: 'بزرگ‌نمایی',
                  onTap: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _mapActionButton(
                  icon: Icons.remove,
                  tooltip: 'کوچک‌نمایی',
                  onTap: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  },
                ),
              ],
            ),
          ),

          // لودینگ اولیه
          if (_loading)
            Container(
              color: Colors.black26,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 14),
                      Text(
                        'در حال اتصال به رادار زنده پروازها...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _mapActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: Colors.grey.shade800),
        ),
      ),
    );
  }
}
