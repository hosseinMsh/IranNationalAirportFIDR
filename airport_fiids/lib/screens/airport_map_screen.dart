import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/airport.dart';
import '../services/translations.dart';

class AirportMapScreen extends StatefulWidget {
  final Airport airport;
  const AirportMapScreen({super.key, required this.airport});

  @override
  State<AirportMapScreen> createState() => _AirportMapScreenState();
}

class _AirportMapScreenState extends State<AirportMapScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _available = {};
  bool _loading = true;
  late AnimationController _animController;
  late Animation<double> _slideUp;

  static const _navApps = <_NavApp>[
    _NavApp(
      translationKey: 'openInBalad',
      icon: Icons.map,
      color: Color(0xFF00A049),
      checkSchemes: ['balad://'],
      launchUrlTemplate: 'https://balad.ir/direction?destination={lat},{lng}',
    ),
    _NavApp(
      translationKey: 'openInNeshan',
      icon: Icons.navigation,
      color: Color(0xFFFF5E00),
      checkSchemes: ['neshan://'],
      launchUrlTemplate: 'https://neshan.org/maps/direction?destination={lat},{lng}&type=driving',
    ),
    _NavApp(
      translationKey: 'openInGoogleMaps',
      icon: Icons.map,
      color: Color(0xFF4285F4),
      checkSchemes: ['comgooglemaps://', 'geo:0,0?q=test'],
      launchUrlTemplate: 'https://www.google.com/maps/dir/?api=1&destination={lat},{lng}&travelmode=driving',
    ),
    _NavApp(
      translationKey: 'openInAppleMaps',
      icon: Icons.navigation,
      color: Color(0xFF34C759),
      checkSchemes: [],
      launchUrlTemplate: 'https://maps.apple.com/?daddr={lat},{lng}&dirflg=d',
    ),
    _NavApp(
      translationKey: 'openInWaze',
      icon: Icons.directions_car,
      color: Color(0xFF33CCFF),
      checkSchemes: ['waze://'],
      launchUrlTemplate: 'https://waze.com/ul?ll={lat},{lng}&navigate=yes',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideUp = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    for (final app in _navApps) {
      if (app.translationKey == 'openInAppleMaps') {
        _available[app.translationKey] =
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;
      } else {
        bool ok = false;
        for (final scheme in app.checkSchemes) {
          if (await canLaunchUrl(Uri.parse(scheme))) {
            ok = true;
            break;
          }
        }
        _available[app.translationKey] = ok;
      }
    }
    if (mounted) {
      setState(() => _loading = false);
      _animController.forward();
    }
  }

  void _openApp(_NavApp app) {
    final url = app.launchUrlTemplate
        .replaceAll('{lat}', widget.airport.latitude.toStringAsFixed(6))
        .replaceAll('{lng}', widget.airport.longitude.toStringAsFixed(6));
    _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
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
          title: Text(widget.airport.name),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(widget.airport.latitude, widget.airport.longitude),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.airport_fiids',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(widget.airport.latitude, widget.airport.longitude),
                      width: 60,
                      height: 60,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withAlpha(80),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.flight,
                                color: Colors.white, size: 24),
                          ),
                          Container(
                            width: 0,
                            height: 0,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 8,
                                ),
                                right: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 8,
                                ),
                                bottom: BorderSide(
                                  color: Colors.transparent,
                                  width: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _slideUp,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_slideUp),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.42,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.flight_takeoff,
                                    color: theme.colorScheme.primary,
                                    size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.airport.name,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      widget.airport.nameEn,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${widget.airport.latitude.toStringAsFixed(2)}, ${widget.airport.longitude.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Divider(color: Colors.grey.shade200),
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2)),
                          )
                        else
                          Flexible(
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              itemCount: _navApps.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (_, i) {
                                final app = _navApps[i];
                                final available =
                                    _available[app.translationKey] == true;
                                return Opacity(
                                  opacity: available ? 1.0 : 0.35,
                                  child: _navButton(
                                    context,
                                    icon: app.icon,
                                    label: t.tr(app.translationKey),
                                    color: app.color,
                                    available: available,
                                    onTap:
                                        available ? () => _openApp(app) : null,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required bool available,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withAlpha(8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withAlpha(30)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Icon(Icons.chevron_left,
                  color: available
                      ? Colors.grey.shade400
                      : Colors.grey.shade300,
                  size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavApp {
  final String translationKey;
  final IconData icon;
  final Color color;
  final List<String> checkSchemes;
  final String launchUrlTemplate;

  const _NavApp({
    required this.translationKey,
    required this.icon,
    required this.color,
    required this.checkSchemes,
    required this.launchUrlTemplate,
  });
}
