import 'package:flutter/foundation.dart';
import 'package:adivery/adivery.dart';

class AdService {
  static const String apiKey = 'cd213aa5-79a5-4dc8-b3ed-f8e4f7ac0d5d';

  // For real ads, replace these with your actual placement IDs from Adivery dashboard
  static const String bannerPlacementId = 'YOUR_BANNER_PLACEMENT_ID';
  static const String interstitialPlacementId = 'YOUR_INTERSTITIAL_PLACEMENT_ID';

  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;
    _initialized = true;

    AdiveryPlugin.initialize(apiKey);
    AdiveryPlugin.setLoggingEnabled(kDebugMode);
    AdiveryPlugin.prepareInterstitialAd(interstitialPlacementId);

    AdiveryPlugin.addListener(
      onError: (placement, error) {
        debugPrint('Adivery error [$placement]: $error');
      },
      onInterstitialLoaded: (placement) {
        debugPrint('Interstitial ad loaded: $placement');
      },
      onRewardedLoaded: (placement) {},
    );
  }

  static Future<void> showInterstitial() async {
    final isLoaded = await AdiveryPlugin.isLoaded(interstitialPlacementId);
    if (isLoaded == true) {
      AdiveryPlugin.show(interstitialPlacementId);
    }
  }

  static void prepareInterstitial() {
    AdiveryPlugin.prepareInterstitialAd(interstitialPlacementId);
  }
}
