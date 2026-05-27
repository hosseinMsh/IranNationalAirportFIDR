import 'package:flutter/material.dart';
import 'package:adivery/adivery_ads.dart';

class AdBanner extends StatefulWidget {
  final String placementId;
  final BannerAdSize size;

  const AdBanner({
    super.key,
    required this.placementId,
    this.size = BannerAdSize.BANNER,
  });

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  bool _loaded = false;
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    if (_failed) return const SizedBox.shrink();
    if (!_loaded) return const SizedBox(height: 1);

    return Container(
      constraints: const BoxConstraints(maxHeight: 60),
      child: BannerAd(
        widget.placementId,
        widget.size,
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdClicked: (_) {},
        onError: (_, __) {
          if (mounted) setState(() => _failed = true);
        },
      ),
    );
  }
}
