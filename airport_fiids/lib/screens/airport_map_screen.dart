import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/airport.dart';
import '../services/translations.dart';

class AirportMapScreen extends StatelessWidget {
  final Airport airport;
  const AirportMapScreen({super.key, required this.airport});

  void _openBalad() {
    final url = 'https://balad.ir/direction?destination=${airport.latitude},${airport.longitude}';
    _launchUrl(url);
  }

  void _openNeshan() {
    final url = 'https://neshan.org/maps/direction?destination=${airport.latitude},${airport.longitude}&type=driving';
    _launchUrl(url);
  }

  void _openGoogleMaps() {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${airport.latitude},${airport.longitude}&travelmode=driving';
    _launchUrl(url);
  }

  void _openAppleMaps() {
    final url = 'https://maps.apple.com/?daddr=${airport.latitude},${airport.longitude}&dirflg=d';
    _launchUrl(url);
  }

  void _openWaze() {
    final url = 'https://waze.com/ul?ll=${airport.latitude},${airport.longitude}&navigate=yes';
    _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = TranslationService.instance;
    return Directionality(
      textDirection: t.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(airport.name),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(airport.latitude, airport.longitude),
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
                        point: LatLng(airport.latitude, airport.longitude),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.flight, color: theme.colorScheme.primary, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flight_takeoff, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${airport.name} (${airport.nameEn})',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${airport.latitude.toStringAsFixed(4)}, ${airport.longitude.toStringAsFixed(4)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 14),
                  _navButton(
                    context,
                    icon: Icons.map,
                    label: t.tr('openInBalad'),
                    color: const Color(0xFF00A049),
                    onTap: _openBalad,
                  ),
                  const SizedBox(height: 8),
                  _navButton(
                    context,
                    icon: Icons.navigation,
                    label: t.tr('openInNeshan'),
                    color: const Color(0xFFFF5E00),
                    onTap: _openNeshan,
                  ),
                  const SizedBox(height: 8),
                  _navButton(
                    context,
                    icon: Icons.map,
                    label: t.tr('openInGoogleMaps'),
                    color: const Color(0xFF4285F4),
                    onTap: _openGoogleMaps,
                  ),
                  const SizedBox(height: 8),
                  _navButton(
                    context,
                    icon: Icons.navigation,
                    label: t.tr('openInAppleMaps'),
                    color: const Color(0xFF34C759),
                    onTap: _openAppleMaps,
                  ),
                  const SizedBox(height: 8),
                  _navButton(
                    context,
                    icon: Icons.directions_car,
                    label: t.tr('openInWaze'),
                    color: const Color(0xFF33CCFF),
                    onTap: _openWaze,
                  ),
                  const SizedBox(height: 12),
                ],
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
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color, size: 22),
        label: Text(label, style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: color.withAlpha(80)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
