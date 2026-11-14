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

  String tr(String key) => _map[key]?[_langCode] ?? _map[key]?['fa'] ?? key;

  static final TranslationService instance = TranslationService._();

  TranslationService._();

  static const Map<String, Map<String, String>> _map = {
    'appTitle': {
      'fa': 'اطلاعات پرواز فرودگاه‌ها',
      'ar': 'معلومات رحلات المطارات',
      'en': 'Iran Airports FIDS',
    },
    'airportsTitle': {
      'fa': 'فرودگاه‌های کشور',
      'ar': 'مطارات البلاد',
      'en': 'Airports',
    },
    'searchAirports': {
      'fa': 'جستجوی نام فرودگاه، شهر یا کد یاتا...',
      'ar': 'ابحث عن مطار، مدينة أو كود إياتا...',
      'en': 'Search airport, city or IATA code...',
    },
    'pinnedAirports': {
      'fa': 'فرودگاه‌های برگزیده',
      'ar': 'المطارات المفضلة',
      'en': 'Pinned Airports',
    },
    'allAirports': {
      'fa': 'همه فرودگاه‌ها',
      'ar': 'جميع المطارات',
      'en': 'All Airports',
    },
    'noAirportsFound': {
      'fa': 'فرودگاهی با این نام یافت نشد',
      'ar': 'لم يتم العثور على مطار',
      'en': 'No matching airports found',
    },
    'pinAirport': {
      'fa': 'افزودن به برگزیده‌ها',
      'ar': 'إضافة إلى المفضلة',
      'en': 'Pin to favorites',
    },
    'unpinAirport': {
      'fa': 'حذف از برگزیده‌ها',
      'ar': 'إزالة من المفضلة',
      'en': 'Unpin from favorites',
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
      'fa': 'جستجو در شرکت، شماره پرواز یا شهر...',
      'ar': 'ابحث عن شركة، رقم رحلة أو وجهة...',
      'en': 'Search airline, flight or city...',
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
    'refresh': {
      'fa': 'تازه‌سازی',
      'ar': 'تحديث',
      'en': 'Refresh',
    },
    'lastUpdate': {
      'fa': 'آخرین به‌روزرسانی',
      'ar': 'آخر تحديث',
      'en': 'Last updated',
    },
    'noFlightsFound': {
      'fa': 'پروازی با این مشخصات یافت نشد',
      'ar': 'لم يتم العثور على رحلة',
      'en': 'No flights found',
    },
    'noFlightsAtAll': {
      'fa': 'هیچ پروازی برای امروز ثبت نشده است',
      'ar': 'لا توجد رحلات مسجلة لليوم',
      'en': 'No flights scheduled for today',
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
      'fa': 'در حال سوار کردن',
      'ar': 'قيد الصعود',
      'en': 'Boarding',
    },
    'statusDeparted': {
      'fa': 'پروازکرد',
      'ar': 'أقلعت',
      'en': 'Departed',
    },
    'flightDetails': {
      'fa': 'جزئیات پرواز',
      'ar': 'تفاصيل الرحلة',
      'en': 'Flight Details',
    },
    'airline': {
      'fa': 'شرکت هواپیمایی',
      'ar': 'شركة الطيران',
      'en': 'Airline',
    },
    'flightNumber': {
      'fa': 'شماره پرواز',
      'ar': 'رقم الرحلة',
      'en': 'Flight Number',
    },
    'originDestination': {
      'fa': 'مبدأ / مقصد',
      'ar': 'المبدأ / الوجهة',
      'en': 'Origin / Destination',
    },
    'scheduledTime': {
      'fa': 'ساعت برنامه‌ای',
      'ar': 'الوقت المجدول',
      'en': 'Scheduled Time',
    },
    'actualTime': {
      'fa': 'ساعت واقعی / تخمینی',
      'ar': 'الوقت الفعلي',
      'en': 'Actual / Estimated',
    },
    'statusLabel': {
      'fa': 'وضعیت پرواز',
      'ar': 'حالة الرحلة',
      'en': 'Flight Status',
    },
    'aircraft': {
      'fa': 'نوع هواپیما',
      'ar': 'طراز الطائرة',
      'en': 'Aircraft',
    },
    'register': {
      'fa': 'علامت ثبت (رجیستر)',
      'ar': 'علامة التسجيل',
      'en': 'Registration',
    },
    'date': {
      'fa': 'تاریخ پرواز',
      'ar': 'تاريخ الرحلة',
      'en': 'Flight Date',
    },
    'shareFlight': {
      'fa': 'اشتراک‌گذاری اطلاعات پرواز',
      'ar': 'مشاركة معلومات الرحلة',
      'en': 'Share Flight Info',
    },
    'copyFlightNumber': {
      'fa': 'کپی شماره پرواز',
      'ar': 'نسخ رقم الرحلة',
      'en': 'Copy Flight Number',
    },
    'copied': {
      'fa': 'شماره پرواز در حافظه کپی شد',
      'ar': 'تم نسخ رقم الرحلة',
      'en': 'Flight number copied to clipboard',
    },
    'navigateToAirport': {
      'fa': 'مسیریابی به فرودگاه',
      'ar': 'الاتجاه إلى المطار',
      'en': 'Navigate to Airport',
    },
    'callAirport': {
      'fa': 'تماس با فرودگاه',
      'ar': 'اتصال بالمطار',
      'en': 'Call Airport',
    },
    'call199': {
      'fa': 'اطلاعات پرواز ۱۹۹',
      'ar': 'استعلامات الطيران ۱۹۹',
      'en': 'Flight Info 199',
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
    'installed': {
      'fa': 'نصب شده',
      'ar': 'مثبت',
      'en': 'Installed',
    },
    'webVersion': {
      'fa': 'تحت وب',
      'ar': 'عبر الويب',
      'en': 'Web version',
    },
    'aboutApp': {
      'fa': 'درباره برنامه',
      'ar': 'عن التطبيق',
      'en': 'About App',
    },
    'disclaimer': {
      'fa': 'سلب مسئولیت',
      'ar': 'إخلاء المسؤولية',
      'en': 'Disclaimer',
    },
    'disclaimerText': {
      'fa': 'این اپلیکیشن کاملاً مستقل بوده و اطلاعات تابلوهای پرواز را به‌صورت برخط و مستقیم از درگاه رسمی شرکت فرودگاه‌ها و ناوبری هوایی ایران (fids.airport.ir) دریافت و نمایش می‌دهد.',
      'ar': 'هذا التطبيق مستقل ويعرض بيانات الرحلات مباشرة من البوابة الرسمية لمطارات إيران.',
      'en': 'This is an independent application displaying live flight information directly from Iran Airports Company (fids.airport.ir).',
    },
    'rateInMyket': {
      'fa': 'ثبت نظر و امتیاز در مایکت',
      'ar': 'تقييم التطبيق في مايكت',
      'en': 'Rate on Myket',
    },
    'checkUpdate': {
      'fa': 'بررسی به‌روزرسانی',
      'ar': 'التحقق من التحديث',
      'en': 'Check for Updates',
    },
    'shareApp': {
      'fa': 'اشتراک‌گذاری برنامه',
      'ar': 'مشاركة التطبيق',
      'en': 'Share App',
    },
    'version': {
      'fa': 'نسخه',
      'ar': 'الإصدار',
      'en': 'Version',
    },
    'enterApp': {
      'fa': 'ورود به برنامه',
      'ar': 'الدخول إلى التطبيق',
      'en': 'Enter App',
    },
    'iranAirports': {
      'fa': 'فرودگاه‌های ایران',
      'ar': 'مطارات إيران',
      'en': 'Airports of Iran',
    },
    'pressBackAgainToExit': {
      'fa': 'برای خروج، دوباره دکمه بازگشت را بزنید',
      'ar': 'اضغط مرة أخرى للخروج',
      'en': 'Press back again to exit',
    },
    'close': {
      'fa': 'بستن',
      'ar': 'إغلاق',
      'en': 'Close',
    },
    'liveRadar': {
      'fa': 'رادار زنده پروازها',
      'ar': 'رادار الرحلات المباشر',
      'en': 'Live Flight Radar',
    },
    'flightsInIranAirspace': {
      'fa': 'پرواز در آسمان ایران',
      'ar': 'رحلة في الأجواء',
      'en': 'Flights in Airspace',
    },
    'searchFlightNumber': {
      'fa': 'جستجوی شماره پرواز یا کالسه‌این...',
      'ar': 'بحث عن رقم الرحلة...',
      'en': 'Search flight number or callsign...',
    },
    'flightAltitude': {
      'fa': 'ارتفاع پرواز',
      'ar': 'ارتفاع الرحلة',
      'en': 'Altitude',
    },
    'flightSpeed': {
      'fa': 'سرعت زمینی',
      'ar': 'السرعة الأرضية',
      'en': 'Ground Speed',
    },
    'flightHeading': {
      'fa': 'سمت و جهت',
      'ar': 'الاتجاه',
      'en': 'Heading',
    },
    'climbing': {
      'fa': 'اوج‌گیری',
      'ar': 'صعود',
      'en': 'Climbing',
    },
    'descending': {
      'fa': 'کاهش ارتفاع',
      'ar': 'هبوط',
      'en': 'Descending',
    },
    'cruising': {
      'fa': 'افقی / کروز',
      'ar': 'طيران مستوٍ',
      'en': 'Cruising',
    },
    'onGround': {
      'fa': 'روی زمین',
      'ar': 'على الأرض',
      'en': 'On Ground',
    },
    'aircraftModel': {
      'fa': 'مدل هواپیما',
      'ar': 'طراز الطائرة',
      'en': 'Aircraft Type',
    },
    'radarDataSource': {
      'fa': 'منبع رادار: آسمان‌جو (Asemanjoo - ODbL)',
      'ar': 'مصدر البيانات: أسمانجوي',
      'en': 'Data Source: Asemanjoo (ODbL)',
    },
  };
}
