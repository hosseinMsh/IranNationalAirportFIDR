import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const _channel = MethodChannel('ir.shraif.airport_fiids/nav_apps');

  final Map<String, bool> _available = {};
  bool _loading = true;
  late AnimationController _animController;
  late Animation<double> _slideUp;

  static const _navApps = <_NavApp>[
    _NavApp(
      id: 'neshan',
      translationKey: 'openInNeshan',
      logoAssetPath: 'assets/images/nav/neshan.png',
      color: Color(0xFFFF5E00),
      androidPackages: [
        'org.rajman.neshan.traffic.tehran.navigator',
        'org.neshan.maps.navigation',
        'org.neshan.nafa',
      ],
      nativeNavUriTemplate: 'nshn:destination?destination={lat},{lng}',
      webFallbackUrlTemplate:
          'https://neshan.org/maps/direction?destination={lat},{lng}&type=driving',
    ),
    _NavApp(
      id: 'balad',
      translationKey: 'openInBalad',
      logoAssetPath: 'assets/images/nav/balad.png',
      color: Color(0xFF00A049),
      androidPackages: [
        'ir.balad',
        'ir.balad.maps',
      ],
      nativeNavUriTemplate: 'balad://direction?destination={lat},{lng}',
      webFallbackUrlTemplate:
          'https://balad.ir/direction?destination={lat},{lng}',
    ),
    _NavApp(
      id: 'google_maps',
      translationKey: 'openInGoogleMaps',
      logoAssetPath: 'assets/images/nav/google_maps.png',
      color: Color(0xFF4285F4),
      androidPackages: [
        'com.google.android.apps.maps',
      ],
      nativeNavUriTemplate: 'google.navigation:q={lat},{lng}&mode=d',
      webFallbackUrlTemplate:
          'https://www.google.com/maps/dir/?api=1&destination={lat},{lng}&travelmode=driving',
    ),
    _NavApp(
      id: 'waze',
      translationKey: 'openInWaze',
      logoAssetPath: 'assets/images/nav/waze.png',
      color: Color(0xFF33CCFF),
      androidPackages: [
        'com.waze',
      ],
      nativeNavUriTemplate: 'waze://?ll={lat},{lng}&navigate=yes',
      webFallbackUrlTemplate:
          'https://waze.com/ul?ll={lat},{lng}&navigate=yes',
    ),
    _NavApp(
      id: 'apple_maps',
      translationKey: 'openInAppleMaps',
      logoAssetPath: 'assets/images/nav/apple_maps.png',
      color: Color(0xFF34C759),
      androidPackages: [],
      nativeNavUriTemplate: 'maps://?daddr={lat},{lng}&dirflg=d',
      webFallbackUrlTemplate:
          'https://maps.apple.com/?daddr={lat},{lng}&dirflg=d',
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
      if (app.id == 'apple_maps') {
        _available[app.id] = defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        bool installed = false;
        try {
          final bool? result = await _channel.invokeMethod<bool>(
            'isAppInstalled',
            {'packages': app.androidPackages},
          );
          installed = result ?? false;
        } catch (_) {}

        if (!installed) {
          // Intent check fallback
          final testUri = Uri.parse(app.nativeNavUriTemplate
              .replaceAll('{lat}', '35.6892')
              .replaceAll('{lng}', '51.3890'));
          installed = await canLaunchUrl(testUri);
        }
        _available[app.id] = installed;
      } else {
        final testUri = Uri.parse(app.nativeNavUriTemplate
            .replaceAll('{lat}', '35.6892')
            .replaceAll('{lng}', '51.3890'));
        _available[app.id] = await canLaunchUrl(testUri);
      }
    }
    if (mounted) {
      setState(() => _loading = false);
      _animController.forward();
    }
  }

  Future<void> _openNavApp(_NavApp app) async {
    final lat = widget.airport.latitude.toStringAsFixed(6);
    final lng = widget.airport.longitude.toStringAsFixed(6);
    final navUri = app.nativeNavUriTemplate
        .replaceAll('{lat}', lat)
        .replaceAll('{lng}', lng);
    final fallbackWebUrl = app.webFallbackUrlTemplate
        .replaceAll('{lat}', lat)
        .replaceAll('{lng}', lng);

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final bool? launched = await _channel.invokeMethod<bool>(
          'launchNav',
          {
            'packages': app.androidPackages,
            'navUri': navUri,
            'fallbackWebUrl': fallbackWebUrl,
          },
        );
        if (launched == true) return;
      } catch (e) {
        debugPrint('Platform channel launch failed: $e');
      }
    }

    // Fallback via url_launcher
    try {
      final nativeUri = Uri.parse(navUri);
      if (await canLaunchUrl(nativeUri)) {
        await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    try {
      final webUri = Uri.parse(fallbackWebUrl);
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _callAirport() async {
    final phone = widget.airport.phone.isNotEmpty ? widget.airport.phone : '199';
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
    final isEn = t.langCode == 'en';
    final displayName = isEn ? widget.airport.nameEn : widget.airport.name;
    final subName = isEn ? widget.airport.name : widget.airport.nameEn;

    final visibleNavApps = _navApps.where((app) {
      if (app.id == 'apple_maps' &&
          defaultTargetPlatform != TargetPlatform.iOS) {
        return false;
      }
      return true;
    }).toList();

    // Sort: installed apps appear first
    final sortedApps = List<_NavApp>.from(visibleNavApps);
    sortedApps.sort((a, b) {
      final aInstalled = _available[a.id] == true;
      final bInstalled = _available[b.id] == true;
      if (aInstalled && !bInstalled) return -1;
      if (!aInstalled && bInstalled) return 1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded),
            tooltip: t.tr('callAirport'),
            onPressed: _callAirport,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter:
                  LatLng(widget.airport.latitude, widget.airport.longitude),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'ir.shraif.airport_fiids',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                        widget.airport.latitude, widget.airport.longitude),
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
                                color:
                                    theme.colorScheme.primary.withAlpha(80),
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
                              bottom: const BorderSide(
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
                    maxHeight: MediaQuery.of(context).size.height * 0.48,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
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
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.flight_takeoff,
                                  color: theme.colorScheme.primary, size: 22),
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
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (widget.airport.iataCode.isNotEmpty) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withAlpha(12),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            widget.airport.iataCode,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    subName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _callAirport,
                              icon: const Icon(Icons.call, size: 16),
                              label: Text(
                                widget.airport.phone.isNotEmpty
                                    ? widget.airport.phone
                                    : '199',
                                style: const TextStyle(fontSize: 11.5),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1),
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      else
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                            itemCount: sortedApps.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final app = sortedApps[i];
                              final available = _available[app.id] == true;
                              return _navButton(
                                context,
                                app: app,
                                label: t.tr(app.translationKey),
                                available: available,
                                onTap: () => _openNavApp(app),
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
    );
  }

  Widget _navButton(
    BuildContext context, {
    required _NavApp app,
    required String label,
    required bool available,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final t = TranslationService.instance;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: available ? Colors.white : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: available
                  ? theme.colorScheme.primary.withAlpha(40)
                  : Colors.grey.shade200,
              width: available ? 1.2 : 0.8,
            ),
            boxShadow: available
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200, width: 0.8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    app.logoAssetPath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.navigation_rounded,
                      color: app.color,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (available)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            t.tr('installed'),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        t.tr('webVersion'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                available
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.open_in_new_rounded,
                size: 14,
                color: available
                    ? theme.colorScheme.primary
                    : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavApp {
  final String id;
  final String translationKey;
  final String logoAssetPath;
  final Color color;
  final List<String> androidPackages;
  final String nativeNavUriTemplate;
  final String webFallbackUrlTemplate;

  const _NavApp({
    required this.id,
    required this.translationKey,
    required this.logoAssetPath,
    required this.color,
    required this.androidPackages,
    required this.nativeNavUriTemplate,
    required this.webFallbackUrlTemplate,
  });
}
