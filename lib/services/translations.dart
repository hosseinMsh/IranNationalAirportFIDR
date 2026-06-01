import 'package:flutter/foundation.dart';

class TranslationService extends ChangeNotifier {
  String _langCode = 'fa';

  String get langCode => _langCode;

  bool get isRtl => _langCode == 'fa' || _langCode == 'ar';

  void setLangCode(String code) {
    if (_langCode == code) return;
    _langCode = code;
    notifyListeners();
  }

  String tr(String key) => _map[key]?[_langCode] ?? key;

  static final TranslationService instance = TranslationService._();

  TranslationService._();
  

  static const Map<String, Map<String, String>> _map = {
    'appTitle': {
      'fa': 'FIDS ایران',
      'ar': 'FIDS إيران',
      'en': 'Iran FIDS',
    },
    'airportsTitle': {
      'fa': 'فرودگاه‌های کشور',
      'ar': 'مطارات البلاد',
      'en': 'Airports',
    },
    'flightInfo': {
      'fa': 'اطلاعات پرواز',
      'ar': 'معلومات الرحلة',
      'en': 'Flight Information',
    },
    'arrivals': {
      'fa': 'ورودی',
      'ar': 'قادم',
      'en': 'Arrivals',
    },
    'departures': {
      'fa': 'خروجی',
      'ar': 'مغادر',
      'en': 'Departures',
    },
    'searchHint': {
      'fa': 'جستجو در شرکت، شماره پرواز یا مبدأ...',
      'ar': 'ابحث عن شركة، رقم رحلة أو وجهة...',
      'en': 'Search airline, flight or origin...',
    },
    'errorLoading': {
      'fa': 'خطا در دریافت اطلاعات',
      'ar': 'خطأ في تحميل المعلومات',
      'en': 'Error loading data',
    },
    'retry': {
      'fa': 'تلاش مجدد',
      'ar': 'إعادة المحاولة',
      'en': 'Retry',
    },
    'noFlightsFound': {
      'fa': 'پروازی با این مشخصات یافت نشد',
      'ar': 'لم يتم العثور على رحلة',
      'en': 'No flights found',
    },
    'noFlightsAtAll': {
      'fa': 'هیچ پروازی یافت نشد',
      'ar': 'لا توجد رحلات',
      'en': 'No flights available',
    },
    'statusLanded': {
      'fa': 'نشست',
      'ar': 'هبطت',
      'en': 'Landed',
    },
    'statusDelayed': {
      'fa': 'تاخیر',
      'ar': 'تأخير',
      'en': 'Delayed',
    },
    'statusCancelled': {
      'fa': 'لغو',
      'ar': 'ملغية',
      'en': 'Cancelled',
    },
    'statusOnSchedule': {
      'fa': 'طبق برنامه',
      'ar': 'حسب الجدول',
      'en': 'On Schedule',
    },
    'statusCheckIn': {
      'fa': 'پذیرش',
      'ar': 'تسجيل وصول',
      'en': 'Check-in',
    },
    'statusInProgress': {
      'fa': 'در حال',
      'ar': 'قيد التنفيذ',
      'en': 'In Progress',
    },
    'statusDeparted': {
      'fa': 'پروازکرد',
      'ar': 'أقلعت',
      'en': 'Departed',
    },
    'navigateToAirport': {
      'fa': 'مسیریابی به فرودگاه',
      'ar': 'الاتجاه إلى المطار',
      'en': 'Navigate to Airport',
    },
    'openInBalad': {
      'fa': 'مسیریابی با بلد',
      'ar': 'الاتجاه مع بلد',
      'en': 'Navigate with Balad',
    },
    'openInNeshan': {
      'fa': 'مسیریابی با نشان',
      'ar': 'الاتجاه مع نشان',
      'en': 'Navigate with Neshan',
    },
    'openInGoogleMaps': {
      'fa': 'باز کردن در گوگل مپ',
      'ar': 'فتح في خرائط جوجل',
      'en': 'Open in Google Maps',
    },
    'openInAppleMaps': {
      'fa': 'باز کردن در اپل مپ',
      'ar': 'فتح في خرائط أبل',
      'en': 'Open in Apple Maps',
    },
    'openInWaze': {
      'fa': 'باز کردن در ویز',
      'ar': 'فتح في ويز',
      'en': 'Open in Waze',
    },
  };
}
