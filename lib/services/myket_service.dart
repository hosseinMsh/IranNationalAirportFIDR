import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// سرویس ارتباط با مایکت بر اساس مستندات رسمی مایکت (Technical Documentation)
/// https://myket.ir/docs/technical/intents/
class MyketService {
  static const String packageName = 'ir.shraif.airport_fiids';
  static const String webUrl = 'https://myket.ir/app/$packageName';

  /// ثبت نظر و امتیاز در مایکت
  /// myket://comment?id=APP_PACKAGE_NAME
  static Future<bool> rateApp() async {
    const uri = 'myket://comment?id=$packageName';
    return _launchUriOrWeb(uri);
  }

  /// بررسی و دریافت نسخه جدید از مایکت (مایکت ۹.۸.۹ به بالا)
  /// myket://check-update?id=APP_PACKAGE_NAME
  static Future<bool> checkUpdate() async {
    const uri = 'myket://check-update?id=$packageName';
    return _launchUriOrWeb(uri);
  }

  /// باز کردن صفحه جزییات برنامه در مایکت
  /// myket://details?id=APP_PACKAGE_NAME
  static Future<bool> openDetailsPage() async {
    const uri = 'myket://details?id=$packageName';
    return _launchUriOrWeb(uri);
  }

  /// نمایش برنامه‌های توسعه‌دهنده در مایکت
  /// myket://developer/APP_PACKAGE_NAME
  static Future<bool> openDeveloperApps() async {
    const uri = 'myket://developer/$packageName';
    return _launchUriOrWeb(uri);
  }

  static Future<bool> _launchUriOrWeb(String myketUriString) async {
    final uri = Uri.parse(myketUriString);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Myket intent launch error: $e');
    }

    // در صورت نصب نبودن مایکت، انتقال به نسخه تحت وب در مرورگر
    try {
      final webUri = Uri.parse(webUrl);
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Myket web fallback launch error: $e');
    }
    return false;
  }
}
